#!/bin/bash

echo "Stopping all services..."
services=("mariadb" "minio" "mysql" "postgres" "rabbitmq" "redis" "traefik")

for service in "${services[@]}"; do
    echo "Stopping $service..."
    (cd "$service" && docker compose down)
done

echo "✅ All services stopped successfully!"
