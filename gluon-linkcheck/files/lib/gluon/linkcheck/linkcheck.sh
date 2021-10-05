#! /bin/sh
valuecheck ()
{
  logstring=$logstring" "$linkname"."$check":"$wert
  if [ ! -f /tmp/linkcheck.$linkname.$check.inhood ] ; then
    if [ "$wert" -gt 1 ] ; then #minimum 2 neighbors
     echo 1>/tmp/linkcheck.$linkname.$check.inhood
    fi
  else
    if [ "$wert" -lt 1 ] ; then # alone?
      if [ -f /tmp/linkcheck.$linkname.$check.linkpb1 ] ; then
        if [ -f /tmp/linkcheck.$linkname.$check.linkpb2 ] ; then
          if [ -f /tmp/linkcheck.$linkname.$check.linkpb3 ] ; then
            logger -s -t "gluon-linkcheck" -p 5 "3nd time no neighbours $linkname.$check, rebooting!"
            sleep 10
            upgrade_started='/tmp/autoupdate.lock'
            [ -f $upgrade_started ] && exit
            reboot -f
           else
            logger -s -t "gluon-linkcheck" -p 5 "still no neighbours $linkname.$check, network restart"
            echo 1>/tmp/linkcheck.$linkname.$check.linkpb3
            /etc/init.d/network restart
            sleep 10
           fi
          logger -s -t "gluon-linkcheck" -p 5 "2nd time no neighbours $linkname.$check, rebooting!"
          sleep 10
          upgrade_started='/tmp/autoupdate.lock'
          [ -f $upgrade_started ] && exit
          reboot -f
        else
          logger -s -t "gluon-linkcheck" -p 5 "still no neighbours $linkname.$check, wifi restart"
          echo 1>/tmp/linkcheck.$linkname.$check.linkpb2
          wifi down
          killall hostapd >/dev/null 2>&1
          rm -f /var/run/wifi-*.pid  >/dev/null 2>&1
          wifi config
          wifi up
          sleep 10
        fi
      else
        logger -s -t "gluon-linkcheck" -p 5 "lost neighbours $linkname.$check"
        echo 1>/tmp/linkcheck.$linkname.$check.linkpb1
      fi
    else
      if [ -f /tmp/linkcheck.$linkname.$check.linkpb1 ] ; then
        rm /tmp/linkcheck.$linkname.$check.linkpb1
      fi
      if [ -f /tmp/linkcheck.$linkname.$check.linkpb2 ] ; then
        rm /tmp/linkcheck.$linkname.$check.linkpb2
      fi
      if [ -f /tmp/linkcheck.$linkname.$check.linkpb3 ] ; then
        rm /tmp/linkcheck.$linkname.$check.linkpb3
      fi
    fi
  fi
}

upgrade_started='/tmp/autoupdate.lock'
[ -f $upgrade_started ] && exit
batversion=$(batctl -v |cut -d" " -f 2|grep -o '[0-9]\+'| tr -d '\012\015')
linkname=batadv
batmeshs=$(batctl if|cut -d":" -f 1|tr '\n' ' ')
for batm in $batmeshs; do
  if [ $batversion -gt 20163 ] ; then
   result=$(batctl n|grep $batm|awk '{print $2}'|sort|uniq|wc -l)
  else
   result=$(batctl n|grep $batm|awk '{print $2}'|sort|uniq|wc -l)
  fi
  check=$batm
  wert=$result
  valuecheck $check
done

checks=""
linksexist=""
links="wireless.mesh_radio0 wireless.batmesh_radio0 wireless.mesh_radio1 wireless.batmesh_radio1 wireless.mesh_radio2 wireless.batmesh_radio2 wireless.client_radio0 wireless.client_radio1 wireless.client_radio2"
for link in $links; do
  linkname=$(uci get $link.ifname 2>/dev/null)
  if [ ! -z "$linkname" ] ; then
    linksexist="$linksexist $link"
   fi
done

for linkexist in $linksexist; do
  linkname=$(uci get $linkexist.ifname)
  bsses=$(iw dev $linkname scan lowpri passive|grep $linkname|wc -l)
  sleep 8
  bssid=$(uci get $linkexist.mesh_id 2>/dev/null)
  if [ -z "$bssid" ] ; then
    bssid=$(uci get $linkexist.ssid)
   fi
  neighbours=$(iw dev $linkname scan lowpri passive|grep $bssid|wc -l)
  sleep 2
  checks="neighbours bsses"
  for check in $checks; do
    wert=$(eval echo \$$check)
    valuecheck $check
  done
done
logger -s -t "gluon-linkcheck" -p 5 $logstring
