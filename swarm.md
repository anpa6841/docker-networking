1. Initialize the Swarm

- docker swarm init

2. Add Worker Nodes (on the same machine)

- ./add-worker-nodes.sh

3. Verify the Swarm

- docker node ls

4. Verify Overlay Network

- docker network inspect my_overlay

<pre>
"Containers": {
    "5ac32340b8cc1499ebb415f218b567934f9c2c1dd58e77a6e0ed17a3513b4d7f": {
        "Name": "worker3",
        "EndpointID": "9f269fcfce474dd8a10395e5d340eb90ccd72b83614866c3d61fa6ab4cc48f6a",
        "MacAddress": "02:42:0a:00:01:05",
        "IPv4Address": "10.0.1.5/24",
        "IPv6Address": ""
    },
    "872ae57e5aa5bd07c897b45188d5e0dc62856043ba6b862afaa014dbcf2cf2a1": {
        "Name": "worker2",
        "EndpointID": "44eb64af803c89aba34350c138a8eb6a273b500aa5b0f181851b11cec363bf62",
        "MacAddress": "02:42:0a:00:01:04",
        "IPv4Address": "10.0.1.4/24",
        "IPv6Address": ""
    },
    "eeba06f4c4dcf29fd6d9afc50f7a3345203a53750fa3053c5b569019c89925a8": {
        "Name": "worker1",
        "EndpointID": "41a7a67b10049026cbc68758e0c50adebfa25bf4ab65ade6bf73c394d8960b94",
        "MacAddress": "02:42:0a:00:01:02",
        "IPv4Address": "10.0.1.2/24",
        "IPv6Address": ""
    },
    "lb-my_overlay": {
        "Name": "my_overlay-endpoint",
        "EndpointID": "1ed15bebda82fdca51d7f5387486ea0f22277a74369efcdf9f80e8dab808d596",
        "MacAddress": "02:42:0a:00:01:03",
        "IPv4Address": "10.0.1.3/24",
        "IPv6Address": ""
    }
}
</pre>

4. Deploy Services

- docker service create --name web --replicas 3 -p 8080:80 --network my_overlay nginx

<pre>
MacBook-Air:docker-networking anish$ docker service ls

ID             NAME      MODE         REPLICAS   IMAGE          PORTS
3jqjb0nr6pvs   web       replicated   3/3        nginx:latest   *:8080->80/tcp        
</pre>

5. Test the Setup

- curl http://[MANAGER_IP]:8080

6. Clean Up

- docker swarm leave --force
- docker rm -f worker1 worker2 worker3
- docker network rm my_overlay
