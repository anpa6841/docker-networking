1. Install networking utilities in nginx containers

- docker build -t nginx .

2. Create a Bridge Network

- docker network create --driver bridge my-bridge-network

3.  Run Containers on the Bridge Network

- docker run -d --name container1 --network my-bridge-network nginx
- docker run -d --name container2 --network my-bridge-network nginx

4. Verify Containers are on the Same Network

- docker network inspect my-bridge-network

<pre>
"Containers": {
    "127e80ef0ae2227b25275f372206406811cbda670ff217d3f6f2f373b734cd55": {
        "Name": "container1",
        "EndpointID": "bf86aa9349ff421df275ed5ac9b05cf701a29268f9d11342d81ab634ccf39005",
        "MacAddress": "02:42:ac:12:00:02",
        "IPv4Address": "172.18.0.2/16",
        "IPv6Address": ""
    },
    "297e665ff7760a8ac13a7cf6e1a0e48743c6a2bf41ca7f6f8b517cb6feeb7d89": {
        "Name": "container2",
        "EndpointID": "0ade7b65b75e952a9a2f927fdfaff940a1117dc16e31e08740bd1cb468eebf38",
        "MacAddress": "02:42:ac:12:00:03",
        "IPv4Address": "172.18.0.3/16",
        "IPv6Address": ""
    }
}
</pre>

5. Communicate Between Containers

- docker exec -it container1 /bin/bash
- ping container2

6. Access the Containers from the Host

- docker run -d --name container1 --network my-bridge-network -p 8080:80 nginx
- curl http://localhost:8080

7. Clean Up

- docker stop container1 container2
- docker rm container1 container2
- docker network rm my-bridge-network
