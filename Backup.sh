#!/bin/bash

# Set temporary PATH
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin;
export PATH="$PATH:test";

RetentionDays=14

# Backup OPNSENSEs latest config files
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub Etienne@OPNSENSE001 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
backupfilename=$(/bin/ls -Art /conf/backup | tail -n 1) && /bin/echo $backupfilename && /usr/local/bin/sudo /usr/local/bin/scp -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub \
/conf/backup/$backupfilename Etienne@NAS:/mnt/Share/Configurations/OPNSENSE/OPNSENSE001.xml;'
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub Etienne@OPNSENSE002 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
backupfilename=$(/bin/ls -Art /conf/backup | tail -n 1) && /bin/echo $backupfilename && /usr/local/bin/sudo /usr/local/bin/scp -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub \
/conf/backup/$backupfilename Etienne@NAS:/mnt/Share/Configurations/OPNSENSE/OPNSENSE002.xml;'
chown -R Etienne:Etienne /mnt/Share/Configurations/OPNSENSE;

# Remove Old SWG001 Backups
find /mnt/Share/Configurations/SWG001/ -type f -iname "*_juniper.conf.gz" -mtime +30 -delete;

# Backup APs
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
echo "Preparing snapshot folder";
btrfs property set -ts /mnt/Share/History/HYPER/$(date +"%Y-%m-%d") ro false;
btrfs property set -ts /mnt/Share/History/HYPER/$(date +"%Y-%m-%d")/* ro false;
btrfs subvolume delete /mnt/Share/History/HYPER/$(date +"%Y-%m-%d")/*;
btrfs subvolume delete /mnt/Share/History/HYPER/$(date +"%Y-%m-%d");
btrfs subvolume create /mnt/Share/History/HYPER/$(date +"%Y-%m-%d");
chown -R Etienne:Etienne /mnt/Share/History/HYPER/$(date +"%Y-%m-%d");

# Backup HYPER002
echo "Backing up HYPER002";
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub Etienne@HYPER002 'sudo mkdir -p /mnt/Share/Configurations/HYPER/HYPER002';
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub Etienne@HYPER002 'sudo chown -R Etienne:Etienne /mnt/Share/Configurations/HYPER/HYPER002';
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub Etienne@HYPER002 'sudo cp -rp /etc/fstab /mnt/Share/Configurations/HYPER/HYPER002/fstab';
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub Etienne@HYPER002 'sudo crontab -l > /mnt/Share/Configurations/HYPER/HYPER002/crontab';
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub Etienne@HYPER002 'cp -rp /home/Etienne /mnt/Share/Configurations/HYPER/HYPER002/';
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/Etienne/.ssh/id_rsa.pub Etienne@HYPER002 'sudo chown -R Etienne:Etienne /mnt/Share/Configurations/HYPER/HYPER002';

# Backup HYPER001
echo "Backing up HYPER001";
mkdir -p /mnt/Share/Configurations/HYPER/HYPER001;
chown -R Etienne:Etienne /mnt/Share/Configurations/HYPER/HYPER001;
cp -rp /etc/fstab /mnt/Share/Configurations/HYPER/HYPER001/fstab;
cp -rp /etc/samba/smb.conf /mnt/Share/Configurations/HYPER/HYPER001/smb.conf;
cp -rp /home/Etienne /mnt/Share/Configurations/HYPER/HYPER001/;
crontab -l > /mnt/Share/Configurations/HYPER/HYPER001/crontab;
chown -R Etienne:Etienne /mnt/Share/Configurations/HYPER/HYPER001/;
btrfs subvolume snapshot -r /mnt/Share/Configurations /mnt/Share/History/HYPER/$(date +"%Y-%m-%d")/Configurations;
btrfs subvolume snapshot -r /mnt/Share/Documents /mnt/Share/History/HYPER/$(date +"%Y-%m-%d")/Documents;
btrfs subvolume snapshot -r /mnt/Share/Medias /mnt/Share/History/HYPER/$(date +"%Y-%m-%d")/Medias;

# Wrapping snapshot
echo "Wrapping up snapshot";
btrfs property set -ts /mnt/Share/History/HYPER/$(date +"%Y-%m-%d") ro true;
find /mnt/Share/History/HYPER -mindepth 1 -maxdepth 1 -type d -ctime +$RetentionDays | while read line; do
  btrfs property set -ts $line ro false;
  btrfs subvolume delete $line/*/*;
  btrfs subvolume delete $line/*;
  btrfs subvolume delete $line;
done;

# Sync with OneDrive
echo "Syncing with Onedrive";
rm -rf /home/Etienne/HK/RClone*.log;

rclone copy  /mnt/Share/History/HYPER/$(date +"%Y-%m-%d")/Medias  OneDrive:HYPER/Medias --metadata --progress --checkers 50 --transfers 50 --delete-excluded --onedrive-chunk-size 5M --config /home/Etienne/HK/RClone/rclone.conf --exclude-from /home/Etienne/HK/RClone/Exclude  --skip-links --log-level=DEBUG --ignore-errors --log-file=/home/Etienne/HK/RClone-HYPER.log;

rclone sync /mnt/Share/History/HYPER/$(date +"%Y-%m-%d")/Configurations  OneDrive:HYPER/Configurations --metadata --delete-during --progress --checkers 50 --transfers 50 --delete-excluded --onedrive-chunk-size 5M --config /home/Etienne/HK/RClone/rclone.conf --exclude-from /home/Etienne/HK/RClone/Exclude  --skip-links --log-level=DEBUG --ignore-errors --log-file=/home/Etienne/HK/RClone-HYPER.log;
rclone sync /mnt/Share/History/HYPER/$(date +"%Y-%m-%d")/Documents  OneDrive:HYPER/Documents --metadata --delete-during --progress --checkers 50 --transfers 50 --delete-excluded --onedrive-chunk-size 5M --config /home/Etienne/HK/RClone/rclone.conf --exclude-from /home/Etienne/HK/RClone/Exclude  --skip-links --log-level=DEBUG --ignore-errors --log-file=/home/Etienne/HK/RClone-HYPER.log;
rclone sync /mnt/Share/History/etien/DARTHVADER  OneDrive:DARTHVADER --metadata --progress --checkers 50 --transfers 50 --delete-excluded --onedrive-chunk-size 5M --config /home/Etienne/HK/RClone/rclone.conf --exclude-from /home/Etienne/HK/RClone/Exclude  --skip-links --log-level=DEBUG --ignore-errors --log-file=/home/Etienne/HK/RClone-DARTHVADER.log;

# Modify Backup.log owner
echo "Modifying log owner";
chown Etienne:Etienne /home/Etienne/HK/*.log;

exit 0;
