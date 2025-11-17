#!/bin/bash

docker stop pdf-annotator
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

echo "Starting PDF Annotator container..."
docker run -d \
    --name pdf-annotator \
    -p 3389:3389 \
    -v "$(pwd)/app.db:/app/app.db" \
    -v "$(pwd)/uploads:/app/uploads" \
    -v "$(pwd)/images:/app/images" \
    -e FLASK_APP=app.py \
    -e FLASK_ENV=production \
    -e SCRIPT_NAME=/Annotation_Tool \
    --restart unless-stopped \
    pdf-annotator:latest

if [ $? -eq 0 ]; then
    echo "✓ Container started successfully!"
    echo "Application is running at http://localhost:3389"
    echo "View logs with: docker logs -f pdf-annotator"
    echo "Stop with: docker stop pdf-annotator"
    echo "Remove with: docker rm pdf-annotator"
else
    echo "✗ Failed to start container"
    exit 1
fi

