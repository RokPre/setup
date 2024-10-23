#!/bin/bash

SMB=/mnt/chromeos/SMB
CLOUDS=$(ls "$SMB")
LOG_FILE=$1
n=0

echo "symlinkToCloud.sh" >> $LOG_FILE
echo "-----------------" >> $LOG_FILE

echo "Found these clouds: $CLOUDS" >> $LOG_FILE

for i in $CLOUDS; do
  # Create a symlink
  ln -s $SMB/$i ~/

  # Check if the item is a directory or a file
  if [ -d "$SMB/$i" ]; then
    # Rename the smbs to "cloud<n>"
    if [ $n -ne 0 ]; then
      mv "$i" ~/cloud"$n"
      echo "Made: ~/cloud$n" >> $LOG_FILE
    else
      mv "$i" ~/cloud
      echo "Made: ~/cloud" >> $LOG_FILE
    fi
    n=$((n + 1))  # Increment the counter
  fi
done
