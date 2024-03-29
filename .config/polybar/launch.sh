#!/bin/bash
killall -q polybar

# Make sure i3 is running
while ! pgrep i3 >/dev/null; do sleep 2; done
sleep 1

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
if type "xrandr" > /dev/null; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload cjiq &
  done
else
  nohup polybar --reload cjiq > /dev/null 2&>1 &
fi

