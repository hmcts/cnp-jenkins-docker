#!/bin/sh

# Start the Docker daemon in the background
nohup /usr/bin/dockerd > /var/log/dockerd.log 2>&1 &

# Wait for the Docker daemon to become available
echo "Waiting for Docker daemon to start..."
attempts=0
max_attempts=30
while ! docker info > /dev/null 2>&1; do
  if [ ${attempts} -eq ${max_attempts} ]; then
    echo "Docker daemon failed to start after ${max_attempts} seconds." >&2
    cat /var/log/dockerd.log >&2
    exit 1
  fi
  attempts=$((attempts + 1))
  sleep 1
done
echo "Docker daemon started successfully."