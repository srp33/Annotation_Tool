# Docker Setup for PDF Annotator

This project can be run in a Docker container for easy deployment.

## Quick Start

### Option 1: Using Docker Compose (Recommended)

```bash
# Build and start the container
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the container
docker-compose down
```

### Option 2: Using Build/Run Scripts

```bash
# Build the Docker image
./docker-build.sh

# Run the container
./docker-run.sh

# Stop the container
./docker-stop.sh
```

### Option 3: Manual Docker Commands

```bash
# Build the image
docker build -t smart:latest .

# Run the container
docker run -d \
    --name smart \
    -p 3389:3389 \
    -v "$(pwd)/app.db:/app/app.db" \
    -v "$(pwd)/uploads:/app/uploads" \
    -v "$(pwd)/images:/app/images" \
    smart:latest

# View logs
docker logs -f smart

# Stop and remove
docker stop smart
docker rm smart
```

## Accessing the Application

Once the container is running, access the application at:
- **http://localhost:3389**

## Data Persistence

The following directories are mounted as volumes to persist data:
- `app.db` - SQLite database
- `uploads/` - Uploaded PDF files
- `images/` - Generated PNG images from PDFs

## Production Notes

- The container runs with **Gunicorn** (not Flask's development server)
- Uses 2 worker processes by default
- Timeout is set to 120 seconds for PDF processing
- Runs in production mode (not debug mode)

## Troubleshooting

### View container logs
```bash
docker logs -f smart
# or with docker-compose
docker-compose logs -f
```

### Rebuild after code changes
```bash
docker-compose build
# or
./docker-build.sh
```

### Check if container is running
```bash
docker ps
```

### Access container shell
```bash
docker exec -it smart /bin/bash
```

