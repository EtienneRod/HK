#!/bin/bash

# Set temporary PATH
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin;
export PATH="$PATH:test";

# Load sensitives info from variables.env in order to not hardcode them in files push to GitHub
# Variable list
  # $pushoverapikey
  # $pushoverusername
export $(grep -v '^#' variables.env | xargs);

appkey=$pushoverapikey
userkey=$pushoverusername
url="https://api.pushover.net/1/messages.json"
message="";

echo "--------";
echo "Updating "$(hostname);
echo "--------";
message="";
apt update && apt -y dist-upgrade && apt -y dist-upgrade;
needrestartoutput=$(/usr/sbin/needrestart -r l -p)
if [[ $needrestartoutput =~ "CRIT - " ]]; then
  message=$(hostname)" - Restart needed after updates - $needrestartoutput";
fi
echo "message=$message";
if [ -n "$message" ]; then
  curl -s \
    --form-string "token=${appkey}" --form-string "user=${userkey}" \
    --form-string "title=Monitoring" \
    --form-string "message=${message}" \
    $url
fi
apt autoremove -y;

/usr/bin/echo "--------";
/usr/bin/echo "Updating CTs";
/usr/bin/echo "--------";
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/tools/pve/update-lxcs-cron.sh)";

# Modify log owner
echo "Modifying log owner";
chown Etienne:Etienne /home/Etienne/HK/*.log;

exit 0;
