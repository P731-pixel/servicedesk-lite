# Local Development Infrastructure

This directory contains the Docker Compose setup for local development.

## Services

| Service | Port | Description |
|---|---|---|
| `postgres-main` | 5432 | Main database for ServiceDesk Lite API |
| `postgres-catalog` | 5433 | External catalog simulation for ODBC integration |
| `keycloak` | 8080 | OIDC Identity Provider (Admin console at `/admin`) |
| `postgres-keycloak` | - | Database for Keycloak |

## How to run

1. Copy the example env file:
   ```bash
   cp infra/.env.example infra/.env