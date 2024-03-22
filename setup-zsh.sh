#!/usr/bin/env bash

# Install zsh
sudo apt-get -y install zsh

# Install zsh plugins
sudo apt-get -y install zsh-autosuggestions zsh-syntax-highlighting

# Copy my zsh config
wget https://raw.githubusercontent.com/shreyas-a-s/test-repo/main/.zshrc
mv .zshrc ~/.zshrc

# Change user shell from bash to zsh
chsh -s /usr/bin/zsh
