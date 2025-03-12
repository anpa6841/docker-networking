1. Shell into the Docker VM and check its interfaces

- docker run --rm -it --privileged --pid=host justincormack/nsenter1
- ip link show # identify the parent interface

2. Setup MacVlan

- ./setup-macvlan.sh

3. Verify Macvlan Network

- docker network inspect macvlan-net

<pre>
"Containers": {
    "2de203ae51534a47e2a923e4c73d6e2d227226203c65c1d904e3e3e32ac9be4c": {
        "Name": "container2",
        "EndpointID": "119700be66d8ad2efe938b313fdeade48295a5fc7be5beae86b5b92d4fbddea5",
        "MacAddress": "02:42:c0:a8:01:66",
        "IPv4Address": "192.168.1.102/24",
        "IPv6Address": ""
    },
    "a3f5fe07f9fb3cbed2224a1a52ecc2f9dd66aa11b7f5e437535026d2d7e86507": {
        "Name": "container1",
        "EndpointID": "7cebca5f7dfaf0958352bbf93a5c7ad9c05aef76b5bc1a1c57df4fab95a5bc26",
        "MacAddress": "02:42:c0:a8:01:65",
        "IPv4Address": "192.168.1.101/24",
        "IPv6Address": ""
    }
}
</pre>

4. Verify Container Configuration

- docker exec -it container1 ip a

<pre>
MacBook-Air:docker-networking anish$ docker exec -it container1 ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: tunl0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN qlen 1000
    link/ipip 0.0.0.0 brd 0.0.0.0
3: ip6tnl0@NONE: <NOARP> mtu 1452 qdisc noop state DOWN qlen 1000
    link/tunnel6 00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00 brd 00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00
118: eth0@if119: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 65535 qdisc noqueue state UP 
    link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.2/16 brd 172.17.255.255 scope global eth0
       valid_lft forever preferred_lft forever
120: eth1@if8: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 65535 qdisc noqueue state UP 
    link/ether 02:42:c0:a8:01:65 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.101/24 brd 192.168.1.255 scope global eth1
       valid_lft forever preferred_lft forever
</pre>

- docker exec -it container2 ip a

<pre>
MacBook-Air:docker-networking anish$ docker exec -it container2 ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: tunl0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN qlen 1000
    link/ipip 0.0.0.0 brd 0.0.0.0
3: ip6tnl0@NONE: <NOARP> mtu 1452 qdisc noop state DOWN qlen 1000
    link/tunnel6 00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00 brd 00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00
121: eth0@if122: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 65535 qdisc noqueue state UP 
    link/ether 02:42:ac:11:00:03 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.3/16 brd 172.17.255.255 scope global eth0
       valid_lft forever preferred_lft forever
123: eth1@if8: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 65535 qdisc noqueue state UP 
    link/ether 02:42:c0:a8:01:66 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.102/24 brd 192.168.1.255 scope global eth1
       valid_lft forever preferred_lft forever
</pre>

5. Test Container Connevtivity

- docker exec -it container1 ping container2
- docker exec -it container2 ping container1

6. Clean Up

- docker stop container1 container2
- docker rm container1 container2
- docker network rm macvlan-net
