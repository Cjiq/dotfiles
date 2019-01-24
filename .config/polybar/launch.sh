#!/bin/bash
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
nohup polybar cjiq & > /dev/null

