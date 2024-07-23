#!/bin/bash

# Backup current network configuration
cp /etc/network/interfaces /etc/network/interfaces.backup

# Function to revert changes
revert_changes() {
    echo "Reverting changes..."
    mv /etc/network/interfaces.backup /etc/network/interfaces
    systemctl restart networking
    exit 1
}

# Apply new configuration
cat << EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eno1
iface eno1 inet manual

auto eno2
iface eno2 inet manual

auto bond0
iface bond0 inet manual
    bond-slaves (interface0) (interface1)
    bond-miimon 100
    bond-mode 802.3ad
    bond-xmit-hash-policy layer2+3

auto vmbr0
iface vmbr0 inet static
    address main_ip/xx
    gateway gateway
    #secondary IP
    post-up ip addr add main_ip/xx dev vmbr0
    bridge-ports bond0
    bridge-stp off
    bridge-fd 0
    bridge-vlan-aware yes

iface vmbr0 inet6 static
    address ipv6_main/xx
    gateway ipv6_gateway

source /etc/network/interfaces.d/*
EOF

# Restart networking
systemctl restart networking

# Initialize variables
start_time=$(date +%s)
end_time=$((start_time + 30))
ping_success=false

echo "Attempting to ping 8.8.8.8 for 30 seconds..."

# Continuously attempt to ping for 30 seconds
while [ $(date +%s) -lt $end_time ]; do
    if ping -c 1 -W 1 8.8.8.8 > /dev/null 2>&1; then
        ping_success=true
        echo "Ping successful!"
        break
    fi
    sleep 1
done

# Check if ping was successful
if [ "$ping_success" = true ]; then
    echo "Network configuration applied successfully."
    rm /etc/network/interfaces.backup
else
    echo "Unable to ping 8.8.8.8 within 30 seconds. Reverting changes..."
    revert_changes
fi