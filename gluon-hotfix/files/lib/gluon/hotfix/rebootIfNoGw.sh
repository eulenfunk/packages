#!/bin/sh
upgrade_started='/tmp/autoupdate.lock'

[ -f $upgrade_started ] && exit

batctl gwl | grep -q "No gateways in range"
if [ $? == 0 ] ; then
  if [ -f /tmp/nogwflag.3 ] ; then
    [ -f $upgrade_started ] && exit
    securereboot
  elif [ -f /tmp/nogwflag.2 ] ; then
    touch /tmp/nogwflag.3
  elif [ -f /tmp/nogwflag.1 ] ; then
    touch /tmp/nogwlflag.2
  else
    touch /tmp/nogwflag.1
  fi
else
  rm -f /tmp/nogwflag.* 2>/dev/null
fi

ipv6_subnet="$(lua -e 'print(require("gluon.site_config").prefix6)' | sed -e 's/\/64//')"
if [ ! -z "$ipv6_subnet" ]; then
  ipv6_anycast="${ipv6_subnet}ac1"
  ping6 "$ipv6_anycast" -c 10 >/dev/null 2>&1
  returnval="$?"
fi
if [ "$returnval" -ne 0 ] || [ -z "$ipv6_subnet" ]; then
  logger "IPv6 Anycast-IP NOT reachable."
  if [ -f /tmp/noip6routerflag.3 ] ; then
    [ -f $upgrade_started ] && exit
    securereboot
    exit 0
  elif [ -f /tmp/noip6routerflag.2 ] ; then
    touch /tmp/noip6routerflag.3
  elif [ -f /tmp/noip6routerflag.1 ] ; then
    touch /tmp/noip6routerflag.2
  else
    touch /tmp/noip6routerflag.1
  fi
else
  logger "IPv6 Anycast-IP reachable."
  rm -f /tmp/noip6routerflag.* 2>/dev/null
fi

#check if wifi is stucking
radio0=$(uci get wireless.radio0) 2>/dev/null
if [ "$?" -eq 0 ] ; then
  rm -f /tmp/wifi.running
  (iw dev > /dev/null && touch /tmp/wifi.running || if [ "$?" -eq 127 ]; then touch /tmp/wifi.running; fi ) &
  sleep 30
  if [ ! -f /tmp/wifi.running ]; then
    [ -f $upgrade_started ] && exit
     securereboot
  fi
fi
