#!/bin/bash

INSTANCEID=$(curl -s -m 60 http://169.254.169.254/latest/meta-data/instance-id)

aws --region ${region} ec2 modify-instance-attribute \
    --instance-id $INSTANCEID \
    --source-dest-check "{\"Value\": false}"

aws --region ${region} ec2 attach-network-interface \
    --device-index 1 \
    --instance-id $INSTANCEID \
    --network-interface-id ${nat_static_network_interface}

while ! ip link show dev eth1; do
    sleep 1
done

sysctl -q -w net.ipv4.ip_forward=1

sysctl -q -w net.ipv4.conf.eth1.send_redirects=0

iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

ip route del default dev eth0