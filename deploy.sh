#!/bin/bash

# Check if IP address is provided
if [ -z "$1" ]; then
    echo "Usage: ./deploy.sh <raspberry-pi-ip>"
    exit 1
fi

PI_IP=$1
PI_USER="pi"

echo "Deploying to Raspberry Pi at $PI_IP..."

# Create remote directory and copy files
echo "Copying files to Raspberry Pi..."
rsync -avz --exclude 'node_modules' --exclude '.git' ./ $PI_USER@$PI_IP:~/rest980/

# SSH into Pi and run setup commands
echo "Setting up on Raspberry Pi..."
ssh $PI_USER@$PI_IP << 'ENDSSH'
    cd ~/rest980
    npm install
    sudo tee /etc/systemd/system/rest980.service << 'EOL'
[Unit]
Description=Rest980 Roomba Control Server
After=network.target

[Service]
Type=simple
User=pi
WorkingDirectory=/home/pi/rest980
ExecStart=/usr/bin/npm start
Restart=on-failure
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
EOL
    sudo systemctl daemon-reload
    sudo systemctl enable rest980
    sudo systemctl start rest980
    echo "Installation complete! Checking service status..."
    sudo systemctl status rest980
ENDSSH

echo "Deployment complete! The service should be running on your Raspberry Pi."
echo "You can check the status with: ssh $PI_USER@$PI_IP 'sudo systemctl status rest980'" 