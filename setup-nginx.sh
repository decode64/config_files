#!/bin/bash

sudo apt install -y nginx

(
cat << EOF
server {
  listen 80 default_server;
  listen [::]:80 default_server;

  server_name vscode;

  location / {
    proxy_pass http://localhost:8000/;
    proxy_set_header Host \$host;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";
  }
}
EOF
) | sudo tee -a /etc/nginx/sites-available/vscode
