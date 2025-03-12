#!/bin/bash

# Create overlay network if it doesn't exist
docker network ls | grep -q my_overlay || docker network create --driver overlay --attachable my_overlay

# Get the join token for workers
JOIN_TOKEN=$(docker swarm join-token worker -q)

# Check if the join token was retrieved successfully
if [ -z "$JOIN_TOKEN" ]; then
    echo "Failed to get worker join token. Is this the manager node?"
    exit 1
fi

# Manager IP (replace with actual IP)
MANAGER_IP="<MANAGER_IP>"

# Create 3 worker nodes
for i in {1..3}; do
    WORKER_NAME="worker${i}"
    
    # Check if the worker already exists
    if docker ps -a --format '{{.Names}}' | grep -q "^${WORKER_NAME}$"; then
        echo "$WORKER_NAME already exists, skipping creation."
    else
        echo "Creating $WORKER_NAME..."
        docker run -d --privileged --name "$WORKER_NAME" --network my_overlay docker:dind
        sleep 5  # Give the Docker daemon inside the container a moment to start

        echo "Joining $WORKER_NAME to the swarm..."
        docker exec "$WORKER_NAME" docker swarm join --token "$JOIN_TOKEN" "$MANAGER_IP":2377
    fi
done

echo "All workers created and joined the swarm!"
