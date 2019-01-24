#!/bin/bash
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
for i in $(polybar -m | awk -F: '{print $1}'); do MONITOR=$i polybar cjiq -c ~/.config/polybar/config & done
feh --bg-scale ~/.config/wall.png

