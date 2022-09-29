#!/bin/bash

export NEEDRESTART_SUSPEND=1

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y \
    git \
    build-essential \
    openssl \
    libssl-dev \
    zlib1g-dev \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Install and configure docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli
sudo usermod -aG docker ${USER}

# Download configuration
curl -fsSL https://raw.githubusercontent.com/decode64/config_files/main/.bashrc --output $HOME/.bashrc
curl -fsSL https://raw.githubusercontent.com/decode64/config_files/main/.gitconfig --output $HOME/.gitconfig

# Install asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2

# Reload bash
exec bash

# Install ruby
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
MAKE_OPTS="-j `cat /proc/cpuinfo | grep processor | wc -l`" RUBY_CONFIGURE_OPTS="--with-openssl-dir=/usr/lib/ssl" asdf install ruby latest

# Install node
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest
