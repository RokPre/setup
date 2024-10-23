#!/bin/bash

echo "This will do everything you need for a fresh Chromebook install"
echo "It will install Obsidian, Syncthing, and Neovim"

# Update package list and upgrade installed packages
sudo apt update -qq && sudo apt upgrade -y -qq

# Install required packages
sudo apt install syncthing libnss3* wl-clipboard curl jq fuse thunar -y -qq

# Create necessary directories
mkdir -p ~/sync ~/offline 
DOWNLOAD_DIR=~/offline
SETUP_DIR=~/cloud/setup
LOG_FILE=$SETUP_DIR/log.log
sudo touch $LOG_FILE

# Link cloud to ~/cloud 
echo "Linking SMB file share to ~/cloud"
echo "-------------------------------"
bash $SETUP_DIR/symlinkToCloud.sh $LOG_FILE

# Syncthing service setup
echo "Seting up syncthing service"
echo "-------------------------------"
bash $SETUP_DIR/serviceSyncthing.sh $LOG_FILE

# Sync dotfiles service setup
echo "Seting up dot files service"
echo "-------------------------------"
bash $SETUP_DIR/serviceDotFiles.sh $LOG_FILE

# Install the latest version of Obsidian
echo "Installing Obsidina.md"
echo "-------------------------------"
bash $SETUP_DIR/installObsidian.sh $LOG_FILE $DOWNLOAD_DIR

# Install the latest version of Neovim
echo "Installing Neovim"
echo "-------------------------------"
bash $SETUP_DIR/installNeovim.sh $LOG_FILE $DOWNLOAD_DIR

# Clean up
# sudo rm -r "$DOWNLOAD_DIR/nvim-linux64.tar.gz"
# rm -rf "$DOWNLOAD_DIR/nvim-linux64"
# rm -rf ~/setup

# Final message
echo "I am finished, now there are a few things that you have to do manually."
echo "- Install Tailscale from the Play Store and log in with Google account."
echo "- Set up SMB cloud in files (My network storage.md)."
echo "- Install a Nerd Font for the terminal (How to change font on Chromebook.md)."
echo "- Configure Syncthing."
