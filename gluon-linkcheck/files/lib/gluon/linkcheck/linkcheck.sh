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
          logger -s -t "gluon-linkcheck" -p 5 "2nd time no neighbours $linkname.$check, rebooting!"
          sleep 10
          upgrade_started='/tmp/autoupdate.lock'
          [ -f $upgrade_started ] && exit
          reboot -f
        else
          logger -s -t "gluon-linkcheck" -p 5 "still no neighbours $linkname.$check, wifi restart"
          echo 1>/tmp/linkcheck.$linkname.$check.linkpb2
          /sbin/wifi
          sleep 10
        fi
      else
        logger -s -t "gluon-linkcheck" -p 5 "lost neighbours $linkname.$check."
        echo 1>/tmp/linkcheck.$linkname.$check.linkpb1
      fi
    else
      if [ -f /tmp/linkcheck.$linkname.$check.linkpb1 ] ; then
        rm /tmp/linkcheck.$linkname.$check.linkpb1
      fi
      if [ -f /tmp/linkcheck.$linkname.$check.linkpb2 ] ; then
        rm /tmp/linkcheck.$linkname.$check.linkpb2
      fi
    fi
  fi
}

upgrade_started='/tmp/autoupdate.lock'
[ -f $upgrade_started ] && exit

linkname=batadv
batmeshs=$(batctl if|cut -d":" -f 1|tr '\n' ' ')
for batm in $batmeshs; do
  result=$(batctl o|grep $batm|cut -d")"  -f 2|cut -d" " -f 2|grep [.?.?:.?.?:.*]|sort|uniq|wc -l)
  check=$batm
  wert=$result
  valuecheck $check
done

checks=""
links="wireless.ibss_radio0.ifname wireless.mesh_radio0.ifname wireless.batmesh_radio0.ifname wireless.ibss_radio1.ifname wireless.mesh_radio1.ifname wireless.batmesh_radio1.ifname"
for link in $links; do
  linkname=$(uci get $link 2>/dev/null)
  if [ ! -z "$linkname" ] ; then
    linknames="$linknames $linkname"
  fi
done
for linkname in $linknames; do
  wadhoc=$(iw dev $linkname scan lowpri passive|grep $linkname|wc -l)
  sleep 8 # this is a hack
  bssid=$(uci get wireless.ibss_radio0.bssid)
  neighbours=$(iw dev $linkname scan lowpri passive|grep $bssid|wc -l)
  checks="neighbours wadhoc"
  for check in $checks; do
    wert=$(eval echo \$$check)
    valuecheck $check
  done
done
logger -s -t "gluon-linkcheck" -p 5 $logstring
