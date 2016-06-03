#!/bin/bash

# Small script to ensure that shairport-sync is running and avaible for devices.

TIMEOUT=15
REFRESH_RATE=5

function getSoundCardStatus()
{
  owner_pid=$(cat /proc/asound/card1/pcm0p/sub0/status | grep owner_pid | cut -d ":" -f 2)
  owner_pid=$(echo "$owner_pid" | sed -e 's/^[ \t]*//') #strip whitespace

  #get name of the current process
  current_name=$(cat /proc/"$owner_pid"/comm)
  echo $current_name
}

function getShairsyncStatus()
{
  s_running=$(systemctl status shairport-sync | grep Active | cut -d ":" -f 2)
  s_running=$(echo "$s_running" | sed -e 's/^[ \t]*//' | cut -d " " -f1) #strip whitespace
  echo $s_running
}

while :
do
  # Get shairsync status and make sure it is running
  getShairsyncStatus
  if [ "$s_running" == "inactive" ]; then
      echo "restarting shairport-sync" 
      systemctl restart shairport-sync
  fi
  in_use=$(cat /proc/asound/card1/pcm0p/sub0/status | grep state | cut -d ":" -f 2)
  in_use=$(echo "$in_use" | sed -e 's/^[ \t]*//') #strip whitespace
  echo $in_use
  if [ "$in_use" == "RUNNING" ]; then

      getSoundCardStatus

      if [ "$current_name" == "shairport-sync" ]; then
          echo "shairsync is in use"
          echo "just chill :3"
      else
        systemctl restart avahi-daemon
        echo "shairsync is not in use"
        echo "restarting avahi"
        sleep $TIMEOUT
      fi
  else
    systemctl restart avahi-daemon
    echo "restarting avahi"
    sleep $TIMEOUT
  fi
  sleep $REFRESH_RATE
done
