LOG_FILE=$1

echo "serviceSyncthing.sh" >> $LOG_FILE
echo "-------------------" >> $LOG_FILE

echo "[Unit]
Description=Syncthing - Open Source Continuous File Synchronization
Documentation=https://docs.syncthing.net/
After=network.target

[Service]
User=$(whoami)
ExecStart=/usr/bin/syncthing -no-browser -logfile=/var/log/syncthing.log -logflags=3
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/syncthing.service > /dev/null

sudo systemctl enable syncthing.service >> $LOG_FILE 2>&1
sudo systemctl start syncthing.service >> $LOG_FILE 2>&1
sudo systemctl status syncthing.service >> $LOG_FILE 2>&1
