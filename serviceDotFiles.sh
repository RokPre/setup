sudo echo "[Unit]
Description=Sync Dotfiles on Startup

[Service]
ExecStart=%h/sync/dotFiles/syncDotFiles.sh
Type=oneshot

[Install]
WantedBy=default.target" | sudo tee /etc/systemd/system/syncDotFiles.service > /dev/null

sudo systemctl enable syncDotFiles.service >> $1 2>&1
sudo systemctl start syncDotFiles.service >> $1 2>&1
sudo systemctl status syncDotFiles.service >> $1 2>&1
