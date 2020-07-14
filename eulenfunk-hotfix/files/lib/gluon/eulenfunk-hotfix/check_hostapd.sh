#!/bin/sh
# check_hostapd for matching pids

restart_wifi() {
  wifi down
  killall hostapd 2>/dev/null
  rm -f /var/run/wifi-*.pid 2>/dev/null
  wifi config
  wifi up
}

pspid=$1
phy=$(echo $@|sed 's/.*-B\ //g'|cut -d" " -f1|sed 's/.*hostapd-//g'|cut -d"." -f1)
if [[ $(echo $phy|grep 'phy') ]] ; then # extrem schlechter Stil, leider kein =~
  pidfile=$(echo $@|sed 's/.*-P\ //g'|cut -d" " -f1)
  pid=$(cat $pidfile 2>/dev/null)
  if [[ $pid == $pspid ]] ; then
    touch /tmp/hostapdpidok.$phy
    rm -f /tmp/hostapdpidfail.$phy.* 2>/dev/null
   elif [ -f /tmp/hostapdpidfail.$phy.2 ] ; then
     logger -s t "eulenfunk-healthcheck" "hostapd restart due to nonmatchings pids on $10"
     restart_wifi
     sleep 10
   elif [ -f /tmp/hostapdpidfail.$phy.1 ] ; then
     touch /tmp/hostapdpidfail.$phy.2
   else
    touch /tmp/hostapdpidfail.$phy.1
   fi
 fi
