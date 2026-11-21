-- Функция смены статуса с логированием (транзакционная безопасность)
CREATE OR REPLACE FUNCTION change_ticket_status(
    p_ticket_id UUID,
    p_new_status_id INT,
    p_employee_id UUID
) RETURNS void AS $$
DECLARE
    v_old_status_id INT;
BEGIN
    -- Получаем старый статус (с блокировкой строки, чтобы избежать race conditions)
    SELECT status_id INTO v_old_status_id 
    FROM tickets 
    WHERE id = p_ticket_id 
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Ticket % not found', p_ticket_id;
    END IF;

    IF v_old_status_id = p_new_status_id THEN
        RETURN; -- Статус не изменился, выходим
    END IF;

    -- Обновляем заявку
    UPDATE tickets 
    SET status_id = p_new_status_id, updated_at = NOW()
    WHERE id = p_ticket_id;

    -- Пишем в аудит
    INSERT INTO audit_log (entity_type, entity_id, action, changed_by, details)
    VALUES (
        'Ticket', 
        p_ticket_id, 
        'StatusChange', 
        p_employee_id, 
        jsonb_build_object('old_status', v_old_status_id, 'new_status', p_new_status_id)
    );
END;
$$ LANGUAGE plpgsql;

-- Функция эскалации просроченных заявок (для фонового Worker'а)
CREATE OR REPLACE FUNCTION escalate_overdue_tickets() RETURNS INT AS $$
DECLARE
    v_escalated_count INT := 0;
    v_ticket RECORD;
    v_escalated_status_id INT;
BEGIN
    -- Находим ID статуса "Escalated" (предполагаем, что он есть в справочнике)
    SELECT id INTO v_escalated_status_id FROM ticket_statuses WHERE name = 'Escalated';
    
    IF v_escalated_status_id IS NULL THEN
        RAISE EXCEPTION 'Status Escalated not found';
    END IF;

    FOR v_ticket IN 
        SELECT id FROM tickets 
        WHERE due_date < NOW() 
            AND status_id NOT IN (
                SELECT id FROM ticket_statuses WHERE name IN ('Closed', 'Escalated')
            )
    LOOP
        UPDATE tickets 
        SET status_id = v_escalated_status_id, updated_at = NOW()
        WHERE id = v_ticket.id;

        INSERT INTO audit_log (entity_type, entity_id, action, details)
        VALUES ('Ticket', v_ticket.id, 'AutoEscalation', '{"reason": "overdue"}');

        v_escalated_count := v_escalated_count + 1;
    END LOOP;

    RETURN v_escalated_count;
END;
$$ LANGUAGE plpgsql;

-- Агрегатное представление для отчетов (привет OLAP)
CREATE MATERIALIZED VIEW mv_agent_load AS
SELECT 
    e.id AS agent_id,
    e.first_name || ' ' || e.last_name AS agent_name,
    ts.name AS status_name,
    COUNT(t.id) AS ticket_count
FROM employees e
LEFT JOIN tickets t ON e.id = t.assigned_to
LEFT JOIN ticket_statuses ts ON t.status_id = ts.id
GROUP BY ROLLUP (e.id, e.first_name, e.last_name, ts.name);

-- Индекс для быстрого обновления materialized view
CREATE UNIQUE INDEX idx_mv_agent_load ON mv_agent_load (agent_id, status_name);