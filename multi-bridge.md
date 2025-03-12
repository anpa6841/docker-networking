1.  Create Multiple Bridge Networks

- Create the first bridge network
    - docker network create --driver bridge --subnet 192.168.1.0/24 --gateway 192.168.1.1 bridge-network-1

- Create the second bridge network
    - docker network create --driver bridge --subnet 192.168.2.0/24 --gateway 192.168.2.1 bridge-network-2

2. Launch Containers on Different Networks

- Launch a container on the first bridge network:
    - docker run -d --name container1 --network bridge-network-1 nginx

- Launch a container on the second bridge network
    - docker run -d --name container2 --network bridge-network-2 nginx

3. Verify Container Connections

- docker inspect container1
- docker inspect container2

- ping container2 from container1 # no connectivity

4. Connect Containers Between Networks And Test Connectivity

- docker network connect bridge-network-2 container1
- docker network connect bridge-network-1 container2
- docker exec -it container1 ping container2
- docker exec -it container2 ping container1

5. Clean Up

- docker network disconnect bridge-network-2 container1
- docker network disconnect bridge-network-1 container2
- docker rm -f container1 container2
- docker network rm bridge-network-1 bridge-network-2
