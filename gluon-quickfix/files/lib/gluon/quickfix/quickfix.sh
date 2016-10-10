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

# fix dead mesh
[ $(iw dev mesh0 station dump | wc -l) -eq 0 ] && iw dev mesh0 scan

###########
# reboots #
###########

# if respondd or dropbear not running, reboot (probably ram was full, so more services might've crashed)
pgrep respondd || reboot
pgrep dropbear || reboot

