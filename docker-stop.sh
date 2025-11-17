#!/bin/bash
# Stop and remove the Docker container

echo "Stopping PDF Annotator container..."
docker stop pdf-annotator 2>/dev/null
docker rm pdf-annotator 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✓ Container stopped and removed"
else
    echo "Container may not have been running"
fi

docker system prune -f