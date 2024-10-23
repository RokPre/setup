#!/bin/bash

LOG_FILE=$1
DOWNLOAD_DIR=$2

LATEST_RELEASE_URL=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest |
  grep "browser_download_url.*nvim-linux64.tar.gz" | grep 256 -v |
  cut -d : -f 2,3 |
  tr -d ' "')

echo $LATEST_RELEASE_URL
if [[ -z "$LATEST_RELEASE_URL" ]]; then
  echo "Error: Could not find the latest release URL."
  exit 1
fi

curl -L "$LATEST_RELEASE_URL" -o "$DOWNLOAD_DIR/nvim-linux64.tar.gz" # Download Neovim tarball
tar -xzf "$DOWNLOAD_DIR/nvim-linux64.tar.gz" -C "$DOWNLOAD_DIR"      # Extract it
sudo mv "$DOWNLOAD_DIR/nvim-linux64/bin/nvim" /usr/local/bin/        # Move Neovim to a directory in PATH
sudo mv "$DOWNLOAD_DIR/nvim-linux64/bin/nvim-git" /usr/local/bin/    # Optional: move git version if exists
