#!/bin/bash

DOWNLOAD_DIR=$2
LOG_FILE=$1
ARCHITECTURE=$(uname -m)

# Check if the download directory and log file are provided
if [[ -z "$DOWNLOAD_DIR" || -z "$LOG_FILE" ]]; then
  echo "Usage: $0 <log_file> <download_directory>"
  exit 1
fi

# Determine the appropriate download URL based on architecture
LATEST_RELEASE_URL=$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | jq -r '.assets[] | select(.name | contains("AppImage")) | .browser_download_url')

if [[ "$ARCHITECTURE" == "aarch64" ]]; then
  LATEST_RELEASE_URL=$(echo "$LATEST_RELEASE_URL" | grep "arm")
else
  LATEST_RELEASE_URL=$(echo "$LATEST_RELEASE_URL" | grep -v "arm")
fi

if [[ -z "$LATEST_RELEASE_URL" ]]; then
  echo "Error: No suitable AppImage found."
  exit 1
fi

echo "Latest Obsidian release URL: $LATEST_RELEASE_URL" >> "$LOG_FILE"

# Download the AppImage
curl -L "$LATEST_RELEASE_URL" -o "$DOWNLOAD_DIR/Obsidian.AppImage"

# Check if the download was successful
if [[ $? -ne 0 ]]; then
  echo "Error: Failed to download Obsidian."
  exit 1
fi

# Make it executable
chmod +x "$DOWNLOAD_DIR/Obsidian.AppImage"

# Create a desktop entry for Obsidian
mkdir -p ~/.local/share/applications
echo "[Desktop Entry]
Name=Obsidian
Comment=Obsidian Notes
Exec=$DOWNLOAD_DIR/Obsidian.AppImage
Icon=$DOWNLOAD_DIR/obsidianIcon.png  # Ensure the icon exists or use a default
Type=Application
Categories=Utility;
Terminal=false
MimeType=x-scheme-handler/obsidian;" | sudo tee ~/.local/share/applications/obsidian.desktop > /dev/null 

# Update the desktop database
update-desktop-database ~/.local/share/applications

# Create Obsidian configuration file (Make sure the directory exists)
mkdir -p ~/.config/obsidian
mkdir -p /home/rok/sync/obsidian
echo '{"vaults":{"":{"path":"/home/rok/sync/obsidian","ts":1729338400472,"open":true}}}' > ~/.config/obsidian/obsidian.json

echo "Obsidian installation completed."

