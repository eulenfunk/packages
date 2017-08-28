#!/bin/sh
# cc0, maintained by adorfer@nadeshda.org 

# wait 60 minutes if autoupdater is running
UPDATEWAIT='60'

safety_exit() {
  logger -s -t "gluon-quickfix" "safety checks failed $@, exiting with error code 2"
  exit 2
}

now_reboot() {
  MSG="rebooting... reason: $@"
  logger -s -t "gluon-quickfix" -p 5 $MSG
  if [ "$(cat /proc/uptime | sed 's/\..*//g')" -gt "3600" ] ; then
    LOG=/lib/gluon/quickfix/reboot.log
    # the first 5 times log the reason for a reboot in a file that is rebootsave
    [ "$(cat $LOG|wc -l)" -gt 5 ] || echo "$(date) $@" >> $LOG
    /sbin/reboot -f
  fi
  logger -s -t "gluon-quickfix" -p 5 "no reboot during first hour"
}

# don't do anything the first 10 minutes
[ "$(cat /proc/uptime | sed 's/\..*//g')" -gt "600" ] || safety_exit "uptime low!"

# stale autoupdater
if [ -f /tmp/autoupdate.lock ] ; then
  MAXAGE=$(($(date +%s)-60*${UPDATEWAIT}))
  LOCKAGE=$(date -r /tmp/autoupdate.lock +%s)
  if [ "$MAXAGE" -gt "$LOCKAGE" ] ; then
    now_reboot "stale autoupdate.lock file"
  fi
  safety_exit "autoupdate running"
 fi

echo safety checks done, continuing...

# batman-adv crash when removing interface in certain configurations
dmesg | grep "Kernel bug" >/dev/null && now_reboot "gluon issue #680"
dmesg | grep ath | grep "alloc of size" | grep "failed" && now_reboot "ath0 malloc fail"
dmesg | grep "ksoftirqd" | grep "page allcocation failure" && now_reboot "kernel malloc fail"

# too many tunneldigger restarts
[ "$(ps |grep -e tunneldigger\ restart -e tunneldigger-watchdog|wc -l)" -ge "9" ] && now_reboot "too many Tunneldigger-Restarts"

# br-client without ipv6 in prefix-range
brc6=$(ip -6 a s dev br-client | awk '/inet6/ { print $2 }'|cut -b1-9 |grep -c $(cat /lib/gluon/site.json|tr "," "\n"|grep \"prefix6\"|cut -d: -f2-3|cut -b2-10) 2>/dev/nul)
if [ "$brc6" == "0" ]; then
  now_reboot "br-client without ipv6 in prefix-range (probably none)"
fi

# respondd or dropbear not running
pgrep respondd >/dev/null || sleep 20; pgrep respondd >/dev/null || now_reboot "respondd not running"
pgrep dropbear >/dev/null || sleep 20; pgrep dropbear >/dev/null || now_reboot "dropbear not running"

# radio0_check for lost neighbours
if [ "$(uci get wireless.radio0)" == "wifi-device" ]; then
  if [ ! "$(uci show|grep wireless.radio0.disabled|cut -d= -f2|tr -d \')" == "1" ]; then
    if ! [[  "$(uci show|grep wireless.mesh_radio0.disabled|cut -d= -f2|tr -d \')" == "1"  &&  "$(uci show|grep wireless.client_radio0.disabled|cut -d= -f2|tr -d \')" == "1"  ]]; then
      echo has radio0 enabled
      [ -f /tmp/iwdev.log ] && rm /tmp/iwdev.log
      iw dev>/tmp/iwdev.log &
      sleep 20
      [ $(cat /tmp/iwdev.log|wc -l) -eq 0 ] && now_reboot "iw dev freezes or radio0 misconfigured"
      DEV="$(iw dev|grep Interface|grep -e 'mesh0' -e 'ibss0'| awk '{ print $2 }'|head -1)"
      scan() {
        logger -s -t "gluon-quickfix" -p 5 "neighbour lost, running iw scan"
        iw dev $DEV scan lowpri passive>/dev/null
      }
      OLD_NEIGHBOURS=$(cat /tmp/mesh_neighbours 2>/dev/null)
      NEIGHBOURS=$(iw dev $DEV station dump | grep -e "^Station " | awk '{ print $2 }')
      echo $NEIGHBOURS > /tmp/mesh_neighbours
      for NEIGHBOUR in $OLD_NEIGHBOURS; do
        echo $NEIGHBOURS | grep $NEIGHBOUR >/dev/null || (scan; break)
      done
    fi
  fi
fi
