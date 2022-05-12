# set up bridge br0
ip link add dev br0 type bridge
ip link set br0 up

# create network namespace ns0, ns1, ns2
ip netns add ns0
ip netns add ns1
ip netns add ns2

# create three veth-pairs
ip link add type veth # veth0, veth1
ip link add type veth # veth2, veth3
ip link add type veth # veth4, veth5

# link veth0, veth2, veth4 to br0, and don't forget set it up
ip link set veth0 up
ip link set veth0 master br0
ip link set veth2 up
ip link set veth2 master br0
ip link set veth4 up
ip link set veth4 master br0

# bind veth1 -> ns0, veth3 -> ns1, veth5 -> ns2
ip link set veth1 netns ns0
ip netns exec ns0 ip link set veth1 up
ip netns exec ns0 ip addr add 10.0.0.1/24 dev veth1

ip link set veth3 netns ns1
ip netns exec ns1 ip link set veth3 up
ip netns exec ns1 ip addr add 10.0.0.2/24 dev veth3

ip link set veth5 netns ns2
ip netns exec ns2 ip link set veth5 up
ip netns exec ns2 ip addr add 10.0.0.3/24 dev veth5

ip netns exec ns0 ip addr
ip netns exec ns1 ip addr
ip netns exec ns2 ip addr

iptables -A FORWARD -i br0 -j ACCEPT





