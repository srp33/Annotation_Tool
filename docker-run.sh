#!/bin/bash

docker stop smart
docker system prune -f

# Handle app.db file
# - If it exists as a file: preserve it (don't touch existing database)
# - If it exists as a directory: fix it (from previous failed mount)
# - If it doesn't exist: create empty file (Docker would create directory otherwise)
if [ -f "$(pwd)/app.db" ]; then
    echo "Using existing database file: app.db"
elif [ -d "$(pwd)/app.db" ]; then
    echo "WARNING: app.db is a directory (from previous failed mount)."
    echo "Removing directory and creating empty database file..."
    rm -rf "$(pwd)/app.db"
    touch "$(pwd)/app.db"
    chmod 666 "$(pwd)/app.db"
else
    echo "Database file doesn't exist. Creating empty database file..."
    echo "Note: This will be an empty database. Your existing data is safe if app.db already exists."
    touch "$(pwd)/app.db"
    chmod 666 "$(pwd)/app.db"
fi

echo "Starting SMART container..."
#docker run -i -t \
docker run -d \
    --name smart \
    -p 3389:3389 \
    -v "$(pwd)/app.db:/app/app.db" \
    -v "$(pwd)/uploads:/app/uploads" \
    -v "$(pwd)/images:/app/images" \
    -e FLASK_APP=app.py \
    -e FLASK_ENV=production \
    -e SCRIPT_NAME=/SMART \
    --restart unless-stopped \
    smart:latest

if [ $? -eq 0 ]; then
    echo "✓ Container started successfully!"
    echo "Application is running at http://localhost:3389"
    echo "View logs with: docker logs -f smart"
    echo "Stop with: docker stop smart"
    echo "Remove with: docker rm smart"
else
    echo "✗ Failed to start container"
    exit 1
fi

