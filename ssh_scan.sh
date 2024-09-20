#!/bin/bash

# Network settings (adjust for your network)
NETWORK="192.168.1"  # The first three octets of the network
START_IP=1           # Starting IP for the scan
END_IP=254           # End IP for the scan
USER="your_username" # SSH username
PASSWORD="your_password" # SSH password (optional, not recommended)

# Loop through each IP in the subnet
for i in $(seq $START_IP $END_IP); do
    IP="$NETWORK.$i"

    # Check if the IP is alive by pinging it
    ping -c 1 -W 1 $IP > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Attempting SSH login to $IP"
        
        # Try to SSH into the device and run 'uname -a'
        sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no -o ConnectTimeout=3 $USER@$IP "uname -a" > /dev/null 2>&1
        
        if [ $? -eq 0 ]; then
            echo "SSH login successful to $IP"
        else
            echo "SSH login failed to $IP"
        fi
    else
        echo "$IP is not reachable"
    fi
done
