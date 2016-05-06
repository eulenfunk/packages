upgrade_started='/tmp/autoupdate.lock'

[ -f $upgrade_started ] && exit

batctl gwl | grep -q "No gateways in range"
if [ $? == 0 ] ; then
  if [ -f /tmp/nogwflag ] ; then
    [ -f $upgrade_started ] && exitr
    securereboot
  else
    touch /tmp/nogwflag
  fi
else
  rm -f /tmp/nogwflag
fi

ipv6_subnet="$(lua -e 'print(require("gluon.site_config").prefix6)' | sed -e 's/\/64//')"
if [ ! -z "$ipv6_subnet" ]; then
  ipv6_anycast="${ipv6_subnet}ac1"
  ping6 "$ipv6_anycast" -c 10 >/dev/null 2>&1
  returnval="$?"
fi
if [ "$returnval" -ne 0 ] || [ -z "$ipv6_subnet" ]; then
  logger "IPv6 Anycast-IP NOT reachable."
  if [ -f /tmp/noip6routerflag ] ; then
    [ -f $upgrade_started ] && exit
    securereboot
    exit 0
  else
    touch /tmp/noip6routerflag
  fi
else
  logger "IPv6 Anycast-IP reachable."
  rm -f /tmp/noip6routerflag
fi

#check if wifi is stucking
rm -f /tmp/wifi.running
(iw dev > /dev/null && touch /tmp/wifi.running || if [ "$?" -eq 127 ]; then touch /tmp/wifi.running; fi ) &
sleep 5
if [ ! -f /tmp/wifi.running ]; then
  [ -f $upgrade_started ] && exit
   securereboot
fi
