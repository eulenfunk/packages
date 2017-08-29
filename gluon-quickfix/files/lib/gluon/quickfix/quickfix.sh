#!/bin/sh
# cc0, maintained by adorfer@nadeshda.org 

# wait 60 minutes if autoupdater is running
UPDATEWAIT='60'

safety_exit() {
  logger -s -t "gluon-quickfix" "safety checks failed $@, exiting with error code 2"
  exit 2
}

now_reboot() {
  # first parameter message
  # second optional -f to force reboot even if autoupdater is running
  logger -s -t "gluon-quickfix" -p 5 "rebooting... reason: $1"
  if [ "$(sed 's/\..*//g' /proc/uptime)" -gt "3600" ] ; then
    LOG=/lib/gluon/quickfix/reboot.log
    # the first 5 times log the reason for a reboot in a file that is rebootsave
    [ "$(wc -l < $LOG)" -gt 5 ] || echo "$(date) $1" >> $LOG
    if [ "$2" != "-f" ] && [ -f /tmp/autoupdate.lock ] ; then
      safety_exit "autoupdate running"
    fi
    /sbin/reboot -f
  fi
  logger -s -t "gluon-quickfix" -p 5 "no reboot during first hour"
}

# don't do anything the first 10 minutes
[ "$(sed 's/\..*//g' /proc/uptime)" -gt "600" ] || safety_exit "uptime low!"

# check for stale autoupdater
if [ -f /tmp/autoupdate.lock ] ; then
  MAXAGE=$(($(date +%s)-60*${UPDATEWAIT}))
  LOCKAGE=$(date -r /tmp/autoupdate.lock +%s)
  if [ "$MAXAGE" -gt "$LOCKAGE" ] ; then
    now_reboot "stale autoupdate.lock file" -f
  fi
  safety_exit "autoupdate running"
fi

# batman-adv crash when removing interface in certain configurations
dmesg | grep -q "Kernel bug" && now_reboot "gluon issue #680"
# ath/ksoftirq-malloc-errors (upcoming oom scenario)
dmesg | grep "ath" | grep "alloc of size" | grep -q "failed" && now_reboot "ath0 malloc fail"
dmesg | grep "ksoftirqd" | grep -q "page allcocation failure" && now_reboot "kernel malloc fail"

# too many tunneldigger restarts
[ "$(ps |grep -c -e tunneldigger\ restart -e tunneldigger-watchdog)" -ge "9" ] && now_reboot "too many Tunneldigger-Restarts"

# br-client without ipv6 in prefix-range
if [ "$(ip -6 addr show to "$(jsonfilter -i /lib/gluon/site.json -e '$.prefix6')" dev br-client | grep -c inet6)" == "0" ]; then
  now_reboot "br-client without ipv6 in prefix-range (probably none)"
fi

reboot_when_not_running() {
  (pgrep $1 || sleep 20 ; pgrep $1 || now_reboot "$1 not running") &> /dev/null
}

# respondd or dropbear not running
reboot_when_not_running respondd
reboot_when_not_running dropbear

iw_dev_reboot_freeze() {
  # first parameter defines the time to wait
  # calls `iw` with the rest of the arguments given to the function
  local t=$1 ; shift
  iw dev $@ &
  # get the bg process
  local p=$!
  sleep $t
  # kill -0 does nothing, but returns true if the process exists
  kill -0 $p 2>/dev/null && now_reboot "'iw dev $@' freezes for more than $t s"
}

scan() {
  # call iw $dev scan to repair defunc wifi
  logger -s -t "gluon-quickfix" -p 5 "neighbour lost, running iw scan"
  iw_dev_reboot_freeze 30 $1 scan lowpri passive>/dev/null
}

# check all radios for lost neighbours
for mesh_radio in `uci show wireless | grep -E -o '(ibss|mesh)_radio[0-9]+' | awk '!seen[$0]++'`; do
  radio="$(uci get wireless.$mesh_radio.device)"
  if [[ "$(uci -q get wireless.$radio.disabled)" != "1" && "$(uci -q get wireless.$mesh_radio.disabled)" != "1" ]]; then
    DEV="$(uci get wireless.$mesh_radio.ifname)"
    N_LOG="/tmp/mesh_neighbours_$mesh_radio"
    OLD_NEIGHBOURS=$(cat $N_LOG 2>/dev/null)
    # fill log with new neighbours
    iw_dev_reboot_freeze 20 $DEV station dump | grep -e "^Station " | cut -f 2 -d ' ' > $N_LOG
    for NEIGHBOUR in $OLD_NEIGHBOURS; do
       grep -q $NEIGHBOUR "$N_LOG" || (scan $DEV; break)
    done
  fi
done
