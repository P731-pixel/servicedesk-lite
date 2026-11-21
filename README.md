# ServiceDesk Lite

Учебно-портфолиный проект: сервисный портал заявок на ИТ-оборудование,
построенный на целевом стеке из вакансии «миграция .NET Framework 4.8 →
.NET 6 / PostgreSQL / Astra Linux».

Цель — не «ещё один CRUD», а **демонстрация компетенций**, требуемых для
миграции legacy-приложений: ADO.NET + Npgsql, PL/pgSQL, Keycloak / OIDC / JWT,
ODBC-интеграции, фоновые задания, кроссплатформенная отчётность,
Nginx + systemd на Astra Linux, React SPA.

## Статус

| Этап | Название                                     | Статус |
|------|----------------------------------------------|--------|
| 0    | Подготовка стенда и репозитория              | 🚧     |
| 1    | Проектирование БД и PL/pgSQL                 | ⏳     |
| 2    | Backend на ASP.NET Core + ADO.NET + Npgsql   | ⏳     |
| 3    | SSO через Keycloak / OIDC / JWT              | ⏳     |
| 4    | ODBC-интеграция и фоновые задачи             | ⏳     |
| 5    | Отчётность: PDF + CSV + агрегаты             | ⏳     |
| 6    | Полноценный React SPA                        | ⏳     |
| 7    | Docker-инфраструктура: Astra, Nginx, systemd | ⏳     |
| 8    | Тестирование, документация, приёмка           | ⏳     |

## Стек

- **Backend:** .NET 10 LTS, ASP.NET Core, ADO.NET, Npgsql, Serilog, Health Checks
- **Frontend:** React 19, TypeScript (strict), Vite, React Router, TanStack Query
- **БД:** PostgreSQL 16 (dev) / Postgres Pro 14 (target prod stand)
- **Identity:** Keycloak 26 (OIDC / JWT)
- **Интеграции:** unixODBC + psqlODBC к внешнему каталогу сотрудников
- **Инфраструктура:** Docker Compose (dev), Astra Linux SE 1.7 + Nginx + systemd (prod stand)

## Структура репозитория

```
backend/   — .NET 10 solution (Clean Architecture)
frontend/  — React SPA
db/        — SQL-миграции и сиды
infra/     — docker-compose, Dockerfile, nginx.conf, systemd-units
docs/      — ADR и архитектурная документация
```

## Быстрый старт

> Заполняется по мере готовности этапов. На этапе 0 доступен только Docker-стенд
> с зависимостями (PostgreSQL, Keycloak).

```bash
cp infra/.env.example infra/.env
docker compose -f infra/docker-compose.dev.yml up -d
```

## Architecture Decision Records

Все ключевые решения зафиксированы в [docs/adr/](docs/adr/):

- [ADR-0001 — .NET 10 LTS](docs/adr/0001-use-net-10-lts.md)
- [ADR-0002 — Monorepo](docs/adr/0002-monorepo.md)
- [ADR-0003 — Стратегия версий PostgreSQL](docs/adr/0003-postgres-version-strategy.md)

## Совместимость с .NET 6

Вакансия целевая — .NET 6 (EOL). Проект реализован на .NET 10 LTS; см.
[ADR-0001](docs/adr/0001-use-net-10-lts.md) — обоснование и оценка усилий
по даунгрейду TFM, если потребуется.

## Лицензия

MIT — см. [LICENSE](LICENSE).