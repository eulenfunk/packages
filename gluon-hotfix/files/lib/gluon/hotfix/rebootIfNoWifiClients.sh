#!/bin/sh
upgrade_started='/tmp/autoupdate.lock'
radio0=$(uci get wireless.radio0) 2>/dev/null
if [ "$?" -eq 0 ] ; then
  L2MESH=$(/usr/sbin/brctl show | sed -n -e '/^br-client[[:space:]]/,/^\S/ { /^\(br-client[[:space:]]\|\t\)/s/^.*\t//p }' | grep -v bat0 | tr '\n' ' ')
  r0ap=$(uci get wireless.client_radio0.disabled) 2>/dev/null
  r1ap=$(uci get wireless.client_radio1.disabled) 2>/dev/null
  if [ $r0ap = '0' ] | [ $r1ap = '0' ] ; then
    CLIENT_MACS=""
    for if in $L2MESH; do
      CLIENT_MACS=`iw dev $if station dump | grep ^Station | cut -d ' ' -f 2`
    done
    clients=0
    for client in $CLIENT_MACS; do
      clients=`expr $i + 1`
    done
    unset CLIENT_MACS SEDDEV

    if [ "$clients" -eq "0" ]; then
      if [ -f $upgrade_started ] && exit
      securereboot 
    fi  
  fi
fi
