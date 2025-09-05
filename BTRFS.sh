#/bin/bash

# Set temporary PATH
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin;
export PATH='$PATH:test';

# Dedup /mnt/Share/Medias/Pictures
bash -c "echo 'Deduping /mnt/Share/Medias/Pictures'";
bash -c "duperemove -r -d /mnt/Share/Medias/Pictures";

# Scrub Data and Metadata to make sure data is not corrupted
bash -c "echo 'Scrubing Data and Metadata'";
bash -c "btrfs scrub start -Bq /mnt/Share";

# Modify Backup.log owner
bash -c "echo 'Modifying log owner'";
bash -c "chown Etienne:Etienne /home/Etienne/HK/*.log";

exit 0;
