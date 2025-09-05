#/bin/bash

# Set temporary PATH
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin;
export PATH="$PATH:test";

# Dedup /mnt/Share/Medias/Pictures
echo "Deduping /mnt/Share/Medias/Pictures";
duperemove -r -d /mnt/Share/Medias/Pictures;

# Scrub Data and Metadata to make sure data is not corrupted
echo "Scrubing Data and Metadata";
btrfs scrub start -Bq /mnt/Share;

# Modify Backup.log owner
echo "Modifying log owner";
chown Etienne:Etienne /home/Etienne/HK/*.log;

exit 0;
