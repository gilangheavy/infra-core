#!/bin/bash

echo "Starting infrastructure setup..."

# 1. Create Network
echo "Creating network traefik-net..."
docker network inspect traefik-net >/dev/null 2>&1 || docker network create traefik-net

# 2. Create Volumes
echo "Creating external volumes..."
volumes=(
    "infrastructure_mariadb_data"
    "infrastructure_minio_data"
    "infrastructure_mysql_data"
    "infrastructure_postgres_data"
    "infrastructure_rabbitmq_data"
    "infrastructure_redis_data"
)

for volume in "${volumes[@]}"; do
    docker volume inspect "$volume" >/dev/null 2>&1 || docker volume create "$volume"
done

# 3. Setup .env files if they don't exist
echo "Checking .env files..."
services=("mariadb" "minio" "mysql" "postgres" "rabbitmq" "redis" "traefik")

for service in "${services[@]}"; do
    if [ ! -f "$service/.env" ]; then
        echo "Creating .env for $service from .env.example..."
        cp "$service/.env.example" "$service/.env"
        echo "⚠️ Please remember to change the default passwords in $service/.env!"
    fi
done

# 4. Start all services
echo "Starting all services..."
for service in "${services[@]}"; do
    echo "Starting $service..."
    (cd "$service" && docker compose up -d)
done

echo "✅ All services started successfully!"
