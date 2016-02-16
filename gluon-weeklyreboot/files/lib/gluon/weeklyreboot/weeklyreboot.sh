#!/bin/sh
DELAYTIME=$(</dev/urandom sed 's/[^[:digit:]]\+//g' | head -c4)
logger -s -t "gluon-weeklyreboot" -p 5 "sheduled reboot in $DELAYTIME seconds"
sleep $DELAYTIME
logger -s -t "gluon-weeklyreboot" -p 5 "sheduled reboot in 5 seconds"
sleep 5
reboot

