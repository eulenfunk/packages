#!/bin/sh

UPGRADESTARTED='/tmp/autoupdate.lock'

safety_exit() {
        echo safety checks failed, exiting with error code 2
        exit 2
}

# if the router started less than 10 minutes ago, exit
[ $(cat /proc/uptime | sed 's/\..*//g') -gt 600 ] || safety_exit

# if autoupdater is running less than 60 minutes, exit. otherwise emergency-reboot
if [ -f $UPGRADESTARTED ] ; then
  UPDATEWAIT='60'
  MAXAGE=$(($(date +%s)-60*${UPDATEWAIT}))
  LOCKAGE=$(date -r /tmp/autoupdate.lock +%s)
  if [ "$MAXAGE" -gt "$LOCKAGE" ] ; then
    _reboot "stale autoupdate.lock file"
   fi
  safety_exit
 fi

echo safety checks done, continuing...

# reboot if there was a kernel (batman) error
# for an example gluon issue #680
dmesg | grep "Kernel bug" >/dev/null && _reboot "gluon issue #680"

if [ "$(uci get wireless.radio0)" eq "wifi-device" ] && [ "$(uci show|grep wireless.radio0.disabled|cut -d"=" -f2)|sed -e "s/r0'1'/OFF/") -ne "OFF" ]  ; then
  echo has wifi enabled
  # check for hanging iw
  [ -f /tmp/iwdev.log ] && rm /tmp/iwdev.log
  iw dev>/tmp/iwdev.log &
  sleep 20
  [ $(cat/tmp/iwdev.log|wc -l) -eq 0 ] && _reboot "iw dev freezes"
 fi


DEV="$(iw dev|grep Interface|grep -e 'mesh0' -e 'ibss0'| awk '{ print $2 }'|head -1)"

scan() {
        logger -s -t "gluon-quickfix" -p 5 "neighbour lost, running iw scan"
        iw dev $DEV scan lowpri passive>/dev/null
}

OLD_NEIGHBOURS=$(cat /tmp/mesh_neighbours 2>/dev/null)
NEIGHBOURS=$(iw dev $DEV station dump | grep -e "^Station " | awk '{ print $2 }')
echo $NEIGHBOURS > /tmp/mesh_neighbours

# check if we have lost any neighbours
for NEIGHBOUR in $OLD_NEIGHBOURS
do
        echo $NEIGHBOURS | grep $NEIGHBOUR >/dev/null || (scan; break)
done

###########
# reboots #
###########

_reboot() {
        logger -s -t "gluon-quickfix" -p 5 "rebooting... reason: $@"
        # push log to server here (nyi)
        # only reboot if the router started less than 1 hour ago
        [ $(cat /proc/uptime | sed 's/\..*//g') -gt 1800 ] || /sbin/reboot -f # comment out for debugging purposes
}

# if respondd or dropbear not running, reboot (probably ram was full, so more services might've crashed)
pgrep respondd >/dev/null || _reboot "respondd not running"
pgrep dropbear >/dev/null || _reboot "dropbear not running"
