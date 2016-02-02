#! /bin/sh
mname=$(uci get wireless.ibss_radio0.ifname) || mname=$(uci get wireless.mesh_radio0.ifname)
if [ -z "$mname" ] ; then
  exit 0
 else
  echo radio: $mname
  mesh=$(batctl o|grep $mname|wc -l) # Keine=1!
  wmesh=$(iw dev $mname scan|grep $mname|wc -l)
  bssid=$(uci get wireless.ibss_radio0.bssid)
  neighbors=$(iw dev $mname scan|grep $bssid|wc -l)
  echo meshneighbours: $mesh adhocneighbors: $wmesh wifimeshneighbors: $neighbors
  if [ ! -f /tmp/noisland ] ; then
    if [ "$neighbors" -gt 2 ] ; then #minimum 2 neighbors
      echo 1>/tmp/noisland
    fi
   else
    if [ "$neighbors" -lt 2 ] ; then
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
