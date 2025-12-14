#!/bin/bash

RetentionDays=14

echo "Start=$(date +'%Y-%m-%d %H:%M:%S')";

# Backup OPNSENSEs latest config files
/usr/bin/echo "Backuping up OPNSense";
/usr/bin/ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub Etienne@OPNSENSE001 'backupfilename=$(/bin/ls -Art /conf/backup | tail -n 1) && /bin/echo $backupfilename && \
/usr/local/bin/sudo /usr/local/bin/scp -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub /conf/backup/$backupfilename Etienne@NAS:/mnt/Share/Configurations/OPNSENSE/OPNSENSE001.xml;'
/usr/bin/ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub Etienne@OPNSENSE002 'backupfilename=$(/bin/ls -Art /conf/backup | tail -n 1) && /bin/echo $backupfilename && \
/usr/local/bin/sudo /usr/local/bin/scp -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub /conf/backup/$backupfilename Etienne@NAS:/mnt/Share/Configurations/OPNSENSE/OPNSENSE002.xml;'
chown -R Etienne:Etienne /mnt/Share/Configurations/OPNSENSE;

# Remove Old SWG001 Backups
/usr/bin/echo "Removing old SWG001 backups";
find /mnt/Share/Configurations/SWG001/ -type f -iname "*_juniper.conf.gz" -mtime +30 -delete;

# Backup APs
/usr/bin/echo "Backuping up APs";
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub root@AP1 sysupgrade --create-backup /tmp/AP1_OpenWRT_backup.tar.gz;
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub root@AP1:/tmp/AP1_OpenWRT_backup.tar.gz /mnt/Share/Configurations/TP-Link/AP1/;
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub root@AP1 rm -f /tmp/AP1_OpenWRT_backup.tar.gz;
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub root@AP2 sysupgrade --create-backup /tmp/AP2_OpenWRT_backup.tar.gz;
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub root@AP2:/tmp/AP2_OpenWRT_backup.tar.gz /mnt/Share/Configurations/TP-Link/AP2/;
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub root@AP2 rm -f /tmp/AP2_OpenWRT_backup.tar.gz;
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub root@AP3 sysupgrade --create-backup /tmp/AP3_OpenWRT_backup.tar.gz;
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub root@AP3:/tmp/AP3_OpenWRT_backup.tar.gz /mnt/Share/Configurations/TP-Link/AP3/;
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub root@AP3 rm -f /tmp/AP3_OpenWRT_backup.tar.gz;

# Preparing Snapshot folder
/usr/bin/echo "Preparing snapshot folder";
/usr/bin/btrfs property set -ts /mnt/Share/History/HYPER/$(date +"%Y-%m-%d") ro false;
/usr/bin/btrfs property set -ts /mnt/Share/History/HYPER/$(date +"%Y-%m-%d")/* ro false;
/usr/bin/btrfs subvolume delete /mnt/Share/History/HYPER/$(date +"%Y-%m-%d")/*;
/usr/bin/btrfs subvolume delete /mnt/Share/History/HYPER/$(date +"%Y-%m-%d");
/usr/bin/btrfs subvolume create /mnt/Share/History/HYPER/$(date +"%Y-%m-%d");
/usr/bin/chown -R Etienne:Etienne /mnt/Share/History/HYPER/$(date +"%Y-%m-%d");

# Backup HYPER002
/usr/bin/echo "Backing up HYPER002";
/usr/bin/ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub Etienne@HYPER002 '/usr/bin/sudo /usr/bin/mkdir -p /mnt/Share/Configurations/HYPER/HYPER002';
/usr/bin/ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub Etienne@HYPER002 '/usr/bin/sudo /usr/bin/chown -R Etienne:Etienne /mnt/Share/Configurations/HYPER/HYPER002';
/usr/bin/ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub Etienne@HYPER002 '/usr/bin/sudo /usr/bin/cp -rp /etc/fstab /mnt/Share/Configurations/HYPER/HYPER002/fstab';
/usr/bin/ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub Etienne@HYPER002 '/usr/bin/sudo crontab -l > /mnt/Share/Configurations/HYPER/HYPER002/crontab';
/usr/bin/ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub Etienne@HYPER002 '/usr/bin/cp -rp /home/Etienne /mnt/Share/Configurations/HYPER/HYPER002/';
/usr/bin/ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub Etienne@HYPER002 '/usr/bin/sudo /usr/bin/chown -R Etienne:Etienne /mnt/Share/Configurations/HYPER/HYPER002';

# Backup HYPER001
/usr/bin/echo "Backing up HYPER001";
/usr/bin/mkdir -p /mnt/Share/Configurations/HYPER/HYPER001;
/usr/bin/chown -R Etienne:Etienne /mnt/Share/Configurations/HYPER/HYPER001;
/usr/bin/cp -rp /etc/fstab /mnt/Share/Configurations/HYPER/HYPER001/fstab;
/usr/bin/cp -rp /etc/samba/smb.conf /mnt/Share/Configurations/HYPER/HYPER001/smb.conf;
/usr/bin/cp -rp /home/Etienne /mnt/Share/Configurations/HYPER/HYPER001/;
/usr/bin/crontab -l > /mnt/Share/Configurations/HYPER/HYPER001/crontab;
/usr/bin/chown -R Etienne:Etienne /mnt/Share/Configurations/HYPER/HYPER001/;
/usr/bin/btrfs subvolume snapshot -r /mnt/Share/Configurations /mnt/Share/History/HYPER/$(date +"%Y-%m-%d")/Configurations;
/usr/bin/btrfs subvolume snapshot -r /mnt/Share/Documents /mnt/Share/History/HYPER/$(date +"%Y-%m-%d")/Documents;
/usr/bin/btrfs subvolume snapshot -r /mnt/Share/Medias /mnt/Share/History/HYPER/$(date +"%Y-%m-%d")/Medias;

# Wrapping snapshot
/usr/bin/echo "Wrapping up snapshot";
/usr/bin/btrfs property set -ts /mnt/Share/History/HYPER/$(date +"%Y-%m-%d") ro true;
/usr/bin/find /mnt/Share/History/HYPER -mindepth 1 -maxdepth 1 -type d -ctime +$RetentionDays | while read line; do
  /usr/bin/btrfs property set -ts $line ro false;
  /usr/bin/btrfs subvolume delete $line/*/*;
  /usr/bin/btrfs subvolume delete $line/*;
  /usr/bin/btrfs subvolume delete $line;
done;

# Sync with S3 EazyBackup
/usr/bin/echo "Syncing with S3 EazyBackup";
/usr/bin/rm -rf /home/Etienne/HK/RClone*.log;
/usr/bin/rclone copy /mnt/Share/History/HYPER/2025-12-09/Medias EazyBackup:share/Medias --metadata --progress --checkers 50 --transfers 50 --s3-chunk-size=128M --s3-upload-concurrency 5 --fast-list --delete-excluded --ignore-existing  --skip-links --ignore-errors --log-level=DEBUG --config /home/Etienne/HK/RClone/rclone.conf --exclude-from /home/Etienne/HK/RClone/Exclude --log-file=/home/Etienne/HK/RClone-HYPER.log;
/usr/bin/rclone copy /mnt/Share/History/HYPER/$(date +"%Y-%m-%d")/Configurations EazyBackup:share/Configurations --metadata --progress --checkers 50 --transfers 50 --s3-chunk-size=128M --s3-upload-concurrency 5 --fast-list --delete-excluded --ignore-existing  --skip-links --ignore-errors --log-level=DEBUG --config /home/Etienne/HK/RClone/rclone.conf --exclude-from /home/Etienne/HK/RClone/Exclude --log-file=/home/Etienne/HK/RClone-HYPER.log;
/usr/bin/rclone copy /mnt/Share/History/HYPER/$(date +"%Y-%m-%d")/Documents EazyBackup:share/Documents --metadata --progress --checkers 50 --transfers 50 --s3-chunk-size=128M --s3-upload-concurrency 5 --fast-list --delete-excluded --ignore-existing  --skip-links --ignore-errors --log-level=DEBUG --config /home/Etienne/HK/RClone/rclone.conf --exclude-from /home/Etienne/HK/RClone/Exclude --log-file=/home/Etienne/HK/RClone-HYPER.log;

# Modify Backup.log owner
/usr/bin/echo "Modifying log owner";
/usr/bin/chown Etienne:Etienne /home/Etienne/HK/*.log;

echo "End=$(date +'%Y-%m-%d %H:%M:%S')";

exit 0;
