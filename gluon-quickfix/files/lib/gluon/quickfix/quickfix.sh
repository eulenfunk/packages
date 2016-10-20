#!/bin/sh

#################
# safety checks #
#################

# if autoupdater is running, exit
pgrep -f autoupdater && exit 0

# if the router started less than 5 minutes ago, exit
[ $(cat /proc/uptime | sed 's/\..*//g') -gt 300 ] || exit 0 

echo safety checks done, continuing...

#########
# fixes #
#########

scan() {
		iw dev mesh0 scan >/dev/null
		logger -s -t "gluon-quickfix" -p 5 "neighbour lost, running iw scan"
}

OLD_NEIGHBOURS=$(cat /tmp/neighbours_mesh0 2>/dev/null)
NEIGHBOURS=$(iw dev mesh0 station dump | grep -e "^Station " | awk '{ print $2 }')
echo $NEIGHBOURS > /tmp/neighbours_mesh0

# check if we have lost any neighbours
for NEIGHBOUR in $OLD_NEIGHBOURS
do
	echo $NEIGHBOURS | grep $NEIGHBOUR >/dev/null || (scan; break)
done

###########
# reboots #
###########

# if respondd or dropbear not running, reboot (probably ram was full, so more services might've crashed)
pgrep respondd >/dev/null || reboot
pgrep dropbear >/dev/null || reboot

# reboot if there was a kernel (batman) error
# for an example gluon issue #910
dmesg | grep -i "kernel bug" >/dev/null && reboot

