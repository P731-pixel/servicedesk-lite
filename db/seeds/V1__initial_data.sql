INSERT INTO ticket_statuses (name) VALUES 
('New'), ('In Progress'), ('Pending User'), ('Escalated'), ('Closed');

-- Сотрудники
INSERT INTO employees (id, email, first_name, last_name, department) VALUES
('11111111-1111-1111-1111-111111111111', 'admin@example.com', 'Ivan', 'Adminov', 'IT'),
('22222222-2222-2222-2222-222222222222', 'agent@example.com', 'Petr', 'Agentov', 'Support'),
('33333333-3333-3333-3333-333333333333', 'user@example.com', 'Sidor', 'Userov', 'Sales');

-- Активы
INSERT INTO assets (name, serial_number) VALUES 
('Dell XPS 15', 'SN-123456'),
('MacBook Pro 16', 'SN-654321');