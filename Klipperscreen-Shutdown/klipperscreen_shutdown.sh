#!/bin/bash

# IP address of the Klipperscreen
ip="192.168.188.46"

# Username and password
user="mks"
password="makerbase"

# Define countdown function
countdown() {
    for i in {5..1}; do
        echo "Shutting down Klipperscreen in: $i"
        sleep 1
    done
    echo "Shutting down Klipperscreen in: 0"
}

# Display countdown
echo "Klipperscreen will be shut down:"
countdown

# Establish SSH connection with disabled host key checking and shut down Klipper screen
sshpass -p "$password" ssh -o StrictHostKeyChecking=no $user@$ip "sudo shutdown -h now -n"

# Check if the Klipper screen has been shut down
sshpass -p "$password" ssh -o StrictHostKeyChecking=no $user@$ip "pgrep klipperscreen > /dev/null"
if [ $? -eq 0 ]; then
  echo "Error: Klipperscreen was not shut down!"
  exit 1
fi

echo "Shutdown completed!"
