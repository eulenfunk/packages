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
  sema="/tmp/hostapdpid"
  if [[ $pid == $pspid ]] ; then
    touch $sema.ok.$phy
    rm -f $sema.fail.$phy.* 2>/dev/null
   elif [ -f $sema.fail.$phy.2 ] ; then
     logger -s -t "eulenfunk-healthcheck" "hostapd restart due to nonmatchings pids on $phy"
     restart_wifi
     rm -f $sema.fail.$phy.* 2>/dev/null
     sleep 10
   elif [ -f $sema.fail.$phy.1 ] ; then
     touch $sema.fail.$phy.2
   else
    touch $sema.fail.$phy.1
   fi
  wifistatus=$(wifi status
  radio="radio"${phy:3:1}
  sema="/tmp/wifipending"
  if [ $(echo $wifistatus|grep -A 6 $radio|cut -d":" -f1-10|grep -c "up: false") -eq 1 && $(echo $wifistatus|grep -A 6 $radio|cut -d":" -f1-10|grep -c "pending: true") -eq 1 ]] ; then
    if [ -f $sema.$radio.2 ] ; then
      logger -s -t "eulenfunk-healthcheck" "hostapd down and pending on $radio"
      restart_wifi
      rm -f $sema.$phy.* 2>/dev/null
      sleep 10
     elif [ -f $sema.$radio.1 ] ; then
      touch $sema.$radio.2
     else
      touch $sema.$radio.1
     fi
    else
     rm -f $sema.$phy.* 2>/dev/null
   fi
 fi
