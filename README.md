# Infrastructure Setup

This repository contains Docker Compose configurations for various infrastructure components. The setup is designed to run behind a **Traefik** reverse proxy, and all services are connected to a shared external Docker network.

## Services Included

- **MariaDB** (Port 3306)
- **MinIO** (Ports 9000, 9001)
- **PostgreSQL** (Port 5432)
- **RabbitMQ** (Ports 5672, 15672)
- **Redis** (Port 6379)
- **Traefik** (Ports 80, 443, 8080)

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Initial Setup

Before starting any of the services, you must create the required external Docker network and volumes.

### 1. Create the External Network

All services communicate through a shared network called `traefik-net`. Create it by running:

```bash
docker network create traefik-net
```

### 2. Create the External Volumes

To ensure data persistence, the services use external Docker volumes. Create them by running:

```bash
docker volume create infrastructure_mariadb_data
docker volume create infrastructure_minio_data
docker volume create infrastructure_postgres_data
docker volume create infrastructure_rabbitmq_data
docker volume create infrastructure_redis_data
```

### 3. Setup Environment Variables

Each service requires specific environment variables. You must create a `.env` file inside each service's directory before starting them.

**MariaDB (`mariadb/.env`):**

```env
MARIADB_PORT=3306
MYSQL_ROOT_PASSWORD=your_secure_password
```

**MinIO (`minio/.env`):**

```env
MINIO_ROOT_USER=admin
MINIO_ROOT_PASSWORD=your_secure_password
```

**PostgreSQL (`postgres/.env`):**

```env
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_secure_password
```

**RabbitMQ (`rabbitmq/.env`):**

```env
RABBITMQ_DEFAULT_USER=admin
RABBITMQ_DEFAULT_PASS=your_secure_password
```

**Traefik (`traefik/.env`):**

```env
TRAEFIK_EMAIL=your-email@example.com
```

_Note: Redis does not require any environment variables by default._

## Usage

To start a specific service, navigate to its directory and run `docker compose up -d`.

For example, to start Traefik and PostgreSQL:

```bash
# Start Traefik
cd traefik
docker compose up -d
cd ..

# Start PostgreSQL
cd postgres
docker compose up -d
cd ..
```

To stop a service, navigate to its directory and run:

```bash
docker compose down
```

## Note on Traefik Let's Encrypt

Traefik is configured to use Let's Encrypt for automatic SSL certificates. The certificates are stored in `traefik/letsencrypt/acme.json`. Ensure that the `letsencrypt` folder exists or is created, and do not commit the certificates to your version control.
