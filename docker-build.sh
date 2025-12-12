#!/bin/bash

docker stop smart
docker system prune -f

docker build -t smart:latest .

if [ $? -eq 0 ]; then
    echo "✓ Docker image built successfully!"
    echo "Run with: ./docker-run.sh"
else
    echo "✗ Docker build failed"
    exit 1
fi

mkdir -p uploads images
chmod 755 uploads images