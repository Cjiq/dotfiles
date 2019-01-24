#!/usr/bin/bash

MAX=100
MIN=1


CURRENT=`cat /sys/class/backlight/acpi_video0/brightness`
echo $CURRENT
if [ -n "$1" ]; then
	DEM=$(set -f; echo $1)
	CURRENT=$(($CURRENT+$DEM))
	if (( $CURRENT < $MIN )); then
		CURRENT=$MIN
	fi
	if (( $CURRENT > $MAX )); then
		CURRENT=$MAX
	fi
	`tee /sys/class/backlight/acpi_video0/brightness <<< $CURRENT` > /dev/null 2>&1
fi
