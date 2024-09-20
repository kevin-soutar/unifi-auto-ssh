#!/bin/sh

# Network settings (adjust for your network)
NETWORK="192.168.1"  # The first three octets of the network
START_IP=1           # Starting IP for the scan
END_IP=254           # End IP for the scan
USER="ubnt" # SSH username

# Loop through each IP in the subnet
i=$START_IP
while [ $i -le $END_IP ]; do
    IP="$NETWORK.$i"

    # Check if the IP is alive by pinging it
    ping -c 1 -W 1 $IP > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "$IP is reachable. Would you like to attempt SSH? (y/n):"
        
        # Ask the user if they want to SSH
        read answer
        if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
            # Attempt SSH connection
            echo "Attempting SSH login to $IP"
            ssh -o StrictHostKeyChecking=no -o ConnectTimeout=3 $USER@$IP "uname -a" > /dev/null 2>&1

            if [ $? -eq 0 ]; then
                echo "SSH login successful to $IP"
            else
                echo "SSH login failed to $IP"
            fi
        else
            echo "Skipping SSH to $IP"
        fi
    else
        echo "$IP is not reachable"
    fi

    i=$((i + 1))
done
