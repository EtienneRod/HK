#!/bin/bash
#/bin/bash
# Load sensitives info from variables.env in order to not hardcode them in files push to GitHub
# Variable list
  # $pushoverapikey
  # $pushoverusername
export $(grep -v '^#' variables.env | xargs);

appkey=$pushoverapikey
userkey=$pushoverusername
url="https://api.pushover.net/1/messages.json"
message="";

/usr/bin/echo "--------";
/usr/bin/echo "Updating "$(hostname);
/usr/bin/echo "--------";
message="";
/usr/bin/apt update && /usr/bin/apt -y dist-upgrade && /usr/bin/apt -y dist-upgrade;
needrestartoutput=$(/usr/sbin/needrestart -r l -p)
if [[ $needrestartoutput =~ "CRIT - " ]]; then
  message=$(hostname)" - Restart needed after updates - $needrestartoutput";
fi
/usr/bin/echo "message=$message";
if [ -n "$message" ]; then
  /usr/bin/curl -s \
    --form-string "token=${appkey}" --form-string "user=${userkey}" \
    --form-string "title=Monitoring" \
    --form-string "message=${message}" \
    $url
fi
/usr/bin/apt autoremove -y;

/usr/bin/echo "--------";
/usr/bin/echo "Updating CTs";
/usr/bin/echo "--------";
bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/tools/pve/update-lxcs-cron.sh)"

# Modify log owner
/usr/bin/echo "Modifying log owner";
/usr/bin/chown Etienne:Etienne /home/Etienne/HK/*.log;

exit 0;
