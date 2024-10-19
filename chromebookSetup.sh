#!/bin/bash

echo "This will do everything you need for a fresh Chromebook install"
echo "It will install Obsidian, Syncthing, and Neovim"

# Update package list and upgrade installed packages
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install syncthing libnss3* wl-clipboard curl -y

# Create necessary directories
mkdir -p ~/sync ~/offline ~/cloud
DOWNLOAD_DIR=~/offline # Remove spaces around "="

# Syncthing service setup
cat <<EOF | sudo tee /etc/systemd/system/syncthing.service
[Unit]
Description=Syncthing - Open Source Continuous File Synchronization
Documentation=https://docs.syncthing.net/
After=network.target

[Service]
User=$(whoami)  # Use current user
ExecStart=/usr/bin/syncthing -no-browser -logfile=/var/log/syncthing.log -logflags=3
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable syncthing.service
sudo systemctl start syncthing.service
sudo systemctl status syncthing.service

# Sync dotfiles service setup
cat <<EOF | sudo tee /etc/systemd/system/syncDotFiles.service
[Unit]
Description=Sync Dotfiles on Startup

[Service]
ExecStart=%h/sync/dotFiles/syncDotFiles.sh
Type=oneshot

[Install]
WantedBy=default.target
EOF

sudo systemctl enable syncDotFiles.service
sudo systemctl start syncDotFiles.service
sudo systemctl status syncDotFiles.service

# Install the latest version of Obsidian
LATEST_RELEASE_URL=$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest |
  grep "browser_download_url.*AppImage" |
  cut -d : -f 2,3 |
  tr -d ' "')

if [[ -z "$LATEST_RELEASE_URL" ]]; then
  echo "Error: Could not find the latest release URL."
  exit 1
else
  curl -L "$LATEST_RELEASE_URL" -o "$DOWNLOAD_DIR/Obsidian.AppImage" # Download the AppImage
  chmod +x "$DOWNLOAD_DIR/Obsidian.AppImage"                         # Make it executable

  # Create a desktop entry for Obsidian
  mkdir -p ~/.local/share/applications
  cat <<EOF >~/.local/share/applications/obsidian.desktop
[Desktop Entry]
Name=Obsidian
Comment=Obsidian Notes
Exec=$DOWNLOAD_DIR/Obsidian.AppImage
Icon=$DOWNLOAD_DIR/obsidianIcon.png  # Make sure the icon exists
Type=Application
Categories=Utility;
Terminal=false
MimeType=x-scheme-handler/obsidian;
EOF

  update-desktop-database ~/.local/share/applications

  # Create Obsidian configuration file (Make sure the directory exists)
  mkdir -p ~/.config/obsidian
  echo '{"vaults":{"":{"path":"/home/rok/sync/obsidian","ts":1729338400472,"open":true}}}' >~/.config/obsidian/obsidian.json
fi

# Install the latest version of Neovim
LATEST_RELEASE_URL=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest |
  grep "browser_download_url.*nvim-linux64.tar.gz" |
  cut -d : -f 2,3 |
  tr -d ' "')

if [[ -z "$LATEST_RELEASE_URL" ]]; then
  echo "Error: Could not find the latest release URL."
  exit 1
fi

curl -L "$LATEST_RELEASE_URL" -o "$DOWNLOAD_DIR/nvim-linux64.tar.gz" # Download Neovim tarball
tar -xzf "$DOWNLOAD_DIR/nvim-linux64.tar.gz" -C "$DOWNLOAD_DIR"      # Extract it
sudo mv "$DOWNLOAD_DIR/nvim-linux64/bin/nvim" /usr/local/bin/        # Move Neovim to a directory in PATH
sudo mv "$DOWNLOAD_DIR/nvim-linux64/bin/nvim-git" /usr/local/bin/    # Optional: move git version if exists

# Clean up
sudo rm -r "$DOWNLOAD_DIR/nvim-linux64.tar.gz" # Remove tarball
rm -rf "$DOWNLOAD_DIR/nvim-linux64"            # Remove extracted files if not needed
rm -rf ~/setup                                 # Remove any setup folder if exists

# Final message
echo "I am finished, now there are a few things that you have to do manually."
echo "- Install Tailscale from the Play Store and log in with Google account."
echo "- Set up SMB cloud in files (My network storage.md)."
echo "- Install a Nerd Font for the terminal (How to change font on Chromebook.md)."
echo "- Configure Syncthing."
