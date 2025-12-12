#!/bin/bash
# Stop and remove the Docker container

echo "Stopping SMART container..."
docker stop smart 2>/dev/null
docker rm smart 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✓ Container stopped and removed"
else
    echo "Container may not have been running"
fi

docker system prune -f