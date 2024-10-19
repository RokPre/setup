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
