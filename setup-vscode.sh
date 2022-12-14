#!/bin/bash

wget -O- https://aka.ms/install-vscode-server/setup.sh | bash

(
cat << EOF
[Unit]
Description=VSCode Server
After=network.target

[Service]
Type=simple
Restart=always
RestartSec=1
User=$USER
ExecStart=/usr/local/bin/code-server serve-local "--without-connection-token" "--accept-server-license-terms"

[Install]
WantedBy=multi-user.target
EOF
) | sudo tee -a /etc/systemd/system/vscode-server.service

sudo systemctl enable vscode-server
