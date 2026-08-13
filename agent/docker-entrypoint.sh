#!/bin/bash
set -e

# If docker socket is mounted, adjust docker group GID to match the socket's GID
if [ -S /var/run/docker.sock ]; then
    DOCKER_SOCK_GID=$(stat -c '%g' /var/run/docker.sock)
    CURRENT_DOCKER_GID=$(getent group docker | cut -d: -f3)
    
    echo "Docker socket GID: $DOCKER_SOCK_GID"
    echo "Container docker group GID: $CURRENT_DOCKER_GID"
    
    if [ "$DOCKER_SOCK_GID" != "$CURRENT_DOCKER_GID" ]; then
        echo "Adjusting docker group GID from $CURRENT_DOCKER_GID to $DOCKER_SOCK_GID"
        groupmod -g "$DOCKER_SOCK_GID" docker
        echo "Docker group GID updated successfully"
    else
        echo "Docker GIDs already match, no adjustment needed"
    fi
fi

# If running as root and JENKINS_USER is set or we want to drop privileges
if [ "$(id -u)" = "0" ]; then
    # Execute command as jenkins user
    exec gosu jenkins "$@"
else
    # Already non-root, just execute
    exec "$@"
fi
