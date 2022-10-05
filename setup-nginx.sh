#!/bin/bash

sudo apt install -y nginx

# Create self signed certificate
sudo mkdir /etc/ssl/private
sudo chmod 700 /etc/ssl/private
sudo openssl req -x509 -nodes -days 1825 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj '/CN=localhost'
sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048


# Create basic auth credentials
sudo sh -c "echo -n '$USER:' >> /etc/nginx/.htpasswd"
echo "Basic auth password:"
read passwd
sudo sh -c "openssl passwd -apr1 ${passwd} >> /etc/nginx/.htpasswd"

(
cat << EOF
server {
  listen 443 ssl;
  listen [::]:443 ssl;

  server_name vscode;

  ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
  ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;
  ssl_dhparam /etc/ssl/certs/dhparam.pem;

  location / {
    proxy_pass http://localhost:8000/;
    proxy_set_header Host \$host;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";

    auth_basic "";
    auth_basic_user_file /etc/nginx/.htpasswd;
  }
}
EOF
) | sudo tee -a /etc/nginx/sites-enabled/vscode

sudo rm /etc/nginx/sites-enabled/default
sudo service nginx restart
