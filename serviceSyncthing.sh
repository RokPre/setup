echo "[Unit]
Description=Syncthing - Open Source Continuous File Synchronization
Documentation=https://docs.syncthing.net/
After=network.target

[Service]
User=$(whoami)  # Use current user
ExecStart=/usr/bin/syncthing -no-browser -logfile=/var/log/syncthing.log -logflags=3
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/syncthing.service > /dev/null

sudo systemctl enable syncthing.service >> $1 2>&1
sudo systemctl start syncthing.service >> $1 2>&1
sudo systemctl status syncthing.service >> $1 2>&1
