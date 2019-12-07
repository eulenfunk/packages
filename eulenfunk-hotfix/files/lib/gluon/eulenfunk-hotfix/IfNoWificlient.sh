#!/bin/sh
upgrade_started='/tmp/autoupdate.lock'

[ -f $upgrade_started ] && exit

cliifs=$(/usr/sbin/brctl show | sed -n -e '/^br-client[[:space:]]/,/^\S/ { /^\(br-client[[:space:]]\|\t\)/s/^.*\t//p }' | grep -v "bat0\|eth\|local-port"| tr '\n' ' ')

APoff=1
for r in 0 1 2; do
  if uci get wireless.radio$r &>/dev/null ; then
    roff=$(uci get wireless.radio$r.disabled 2>/dev/null)
    if [ -z $roff ] || [ ! "$roff" -eq "1" ] ; then
      coff=$(uci get wireless.client_radio$r.disabled 2>/dev/null);
      if [ -z $coff ] || [ ! "$coff" -eq "1" ] ; then
        APoff=0
       fi
     fi
   fi
 done

[ "$APoff" -eq "1" ] && exit 0
C_MACS=""
for if in $cliifs; do
  C_MACS=${C_MACs}$(iw dev $if station dump | grep ^Station | cut -d ' ' -f 2)
 done

if [ -z "$C_MACS" ] ; then
  if [ -f /tmp/WifiClients ] ; then
    if [ -f /tmp/NoWiCli.3 ] ; then
      [ -f $upgrade_started ] && exit
      logger -s -t "hotfix-IfNoWificlient" -p 5 "wireless stations disappeared for long, restarting Wifi"
      rm -f /tmp/WifiClients 2>/dev/null
      rm -f /tmp/NoWiCli.* 2>/dev/null
      wifi
    elif [ -f /tmp/NoWiCli.2 ] ; then
      touch /tmp/NoWiCli.3
    elif [ -f /tmp/NoWiCli.1 ] ; then
      touch /tmp/NoWiCli.2
    else
      touch /tmp/NoWiCli.1
    fi
  fi
else
  touch /tmp/WifiClients
  rm -f /tmp/NoWiCli.* 2>/dev/null
fi

