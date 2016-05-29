#!/bin/bash 

# Program to check if shairsync is running otherwise restart avahi to prohibit
# that shairsycn cannot be foound

while :
do		 
		running=$(cat /proc/asound/card1/pcm0p/sub0/status | grep state | cut -d ":" -f 2)
		running=$(echo "$running" | sed -e 's/^[ \t]*//') #strip whitespace
		if [ "$running" == "RUNNING" ]; then
				owner_pid=$(cat /proc/asound/card1/pcm0p/sub0/status | grep owner_pid | cut -d ":" -f 2)
				owner_pid=$(echo "$owner_pid" | sed -e 's/^[ \t]*//') #strip whitespace

				# echo "$owner_pid"
				#get name of the current process
				current_name=$(cat /proc/"$owner_pid"/comm)
				echo $current_name

				if [ "$current_name" == "shairport-sync" ]; then
				echo "shairsync is running"
				else
				systemctl restart avahi-daemon
				echo "shairsync is not running"
				fi
		else
  		systemctl restart avahi-daemon
			echo "restarting avahi"
			sleep 10
		fi
		sleep 5
done		

