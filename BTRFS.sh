#/bin/bash

# Dedup /mnt/Share/Medias/Pictures
/usr/bin/echo "Deduping /mnt/Share/Medias/Pictures";
/usr/bin/duperemove -r -d /mnt/Share/Medias/Pictures;

# Scrub Data and Metadata to make sure data is not corrupted
/usr/bin/echo "Scrubing Data and Metadata";
/usr/bin/btrfs scrub start -Bq /mnt/Share;

# Modify Backup.log owner
/usr/bin/echo "Modifying log owner";
/usr/bin/chown Etienne:Etienne /home/Etienne/HK/*.log;

exit 0;
