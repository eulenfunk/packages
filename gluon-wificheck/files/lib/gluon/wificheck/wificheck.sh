#! /bin/sh
mname=$(uci get wireless.ibss_radio0.ifname) || mname=$(uci get wireless.mesh_radio0.ifname)
if [ -z "$mname" ] ; then
  exit 0
 else
  echo radio: $mname
  mesh=$(batctl o|grep ibss0|cut -d")"  -f 2|cut -d" " -f 2|grep [.?.?:.?.?:.*]|sort|uniq|wc -l)
  wmesh=$(iw dev $mname scan|grep $mname|wc -l)
  bssid=$(uci get wireless.ibss_radio0.bssid)
  neighbors=$(iw dev $mname scan|grep $bssid|wc -l)
  echo ibss-bat-neighbours: $mesh wifiadhocs-neighbors: $wmesh wifimesh-neighbors: $neighbors
  if [ ! -f /tmp/noisland ] ; then
    if [ "$mesh" -gt 1 ] ; then #minimum 2 neighbors
      echo 1>/tmp/noisland
    fi
   else
    if [ "$mesh" -lt 1 ] ; then # alone?
      if [ -f /tmp/wifipbflag ] ; then
        echo "still no wifi neighbors, rebooting"
        sleep 3
        reboot -f
       else
        echo "lost wifi neighbors."
        echo 1>/tmp/wifipbflag
       fi
    else
     if [ -f /tmp/wifipbflag ] ; then
       rm /tmp/wifipbflag
      fi
    fi
   fi
 fi
