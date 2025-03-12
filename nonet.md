1. Run a Container with none Network

- docker run -it --network none alpine sh

2. Test Network Connectivity

- ping google.com
- ip a
- wget http://example.com

3. Verify No Network Assigned

- docker ps -a
- docker inspect [container_id]
