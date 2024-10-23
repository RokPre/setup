LOG_FILE=$1

echo "serviceDotFile.sh" >> $LOG_FILE
echo "-----------------" >> $LOG_FILE

sudo echo "[Unit]
Description=Sync Dotfiles on Startup

[Service]
ExecStart=%h/sync/dotFiles/syncDotFiles.sh
Type=oneshot

[Install]
WantedBy=default.target" | sudo tee /etc/systemd/system/syncDotFiles.service > /dev/null

sudo systemctl enable syncDotFiles.service >> $LOG_FILE 2>&1
sudo systemctl start syncDotFiles.service >> $LOG_FILE 2>&1
sudo systemctl status syncDotFiles.service >> $LOG_FILE 2>&1
