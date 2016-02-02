#!/bin/sh
DELAYTIME=$(</dev/urandom sed 's/[^[:digit:]]\+//g' | head -c4)
echo sheduled reboot in $DELAYTIME seconds
sleep $DELAYTIME
echo sheduled reboot in 5 seconds
sleep 5
reboot

