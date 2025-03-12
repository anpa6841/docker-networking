#!/bin/bash

# Set variables
IMAGE_NAME="alpine"
NETWORK_NAME="macvlan-net"
PARENT_IF="eth0"  # Change this to your actual parent interface
SUBNET="192.168.1.0/24"
GATEWAY="192.168.1.1"
CONTAINER1_IP="192.168.1.101"
CONTAINER2_IP="192.168.1.102"

# Create macvlan network
docker network create -d macvlan \
  --subnet=$SUBNET \
  --gateway=$GATEWAY \
  -o parent=$PARENT_IF $NETWORK_NAME

# Create and configure Container 1 with bridge network
docker run -dit --name container1 --network bridge "$IMAGE_NAME"
docker network connect --ip "$CONTAINER1_IP" "$NETWORK_NAME" container1

# Create and configure Container 2 with bridge network
docker run -dit --name container2 --network bridge "$IMAGE_NAME"
docker network connect --ip "$CONTAINER2_IP" "$NETWORK_NAME" container2
