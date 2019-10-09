#!/bin/sh
upgrade_started='/tmp/autoupdate.lock'

[ -f $upgrade_started ] && exit

batctl gwl | grep -q "No gateways in range"
if [ $? == 0 ] ; then
  if [ -f /tmp/gw ] ; then
    if [ -f /tmp/gwgone.3 ] ; then
      [ -f $upgrade_started ] && exit
      securereboot
    elif [ -f /tmp/gwgone.2 ] ; then
      touch /tmp/gwgone.3
    elif [ -f /tmp/gwgone.1 ] ; then
      touch /tmp/gwgone.2
    else
      touch /tmp/gwgone.1
    fi
  fi
else
  touch /tmp/gw
  rm -f /tmp/gwgone.* 2>/dev/null
fi

ipv6_subnet="$(lua -e 'print(require("gluon.site").prefix6())' | sed -e 's/\/64//')"
if [ ! -z "$ipv6_subnet" ]; then
  ipv6_anycast="${ipv6_subnet}ac1"
  ping6 "$ipv6_anycast" -c 10 >/dev/null 2>&1
  returnval="$?"
fi
if [ "$returnval" -ne 0 ] || [ -z "$ipv6_subnet" ]; then
  if [ -f /tmp/ip6anycast ] ; then
    logger "IPv6 Anycast-IP NOT reachable."
    if [ -f /tmp/ip6anycastgone.3 ] ; then
      [ -f $upgrade_started ] && exit
      securereboot
      exit 0
    elif [ -f /tmp/ip6anycastgone.3 ] ; then
      touch /tmp/ip6anycastgone.3
    elif [ -f /tmp/ip6anycastgone.1 ] ; then
      touch /tmp/ip6anycastgone.2
    else
      touch /tmp/ip6anycastgone.1
    fi
  fi
else
  logger "IPv6 Anycast-IP reachable."
  touch /tmp/ip6anycast
  rm -f /tmp/ip6anycastgone.* 2>/dev/null
fi
