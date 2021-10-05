#! /bin/sh
mname=$(uci get wireless.mesh_radio0.ifname)
bssid=$(uci get wireless.mesh_radio0.mesh_id)
if [ -z "$mname" ] || [ -z "$bssid" ]; then
  exit 0
 else
  echo radio: $mname
  wmesh=$(iw dev $mname scan lowpri passive|grep $mname|wc -l)
  sleep 4 # this is a hack
  neighbours=$(iw dev $mname scan lowpri passive|grep $bssid|wc -l)
  sleep 4 
  mesh=$(batctl o|grep $mname|cut -d")"  -f 2|cut -d" " -f 2|grep [.?.?:.?.?:.*]|sort|uniq|wc -l)
  logger -s -t "gluon-wificheck" -p 5 "ibss-bat-neighbours: $mesh wifiadhocs-neighbours: $wmesh wifimesh-neighbours: $neighbours"
  if [ ! -f /tmp/noisland ] ; then
    if [ "$mesh" -gt 1 ] ; then #minimum 2 neighbors
      echo 1>/tmp/noisland
    fi
   else
    if [ "$mesh" -lt 1 ] ; then # alone?
      if [ -f /tmp/wifipbflag ] ; then
        if [ -f /tmp/wifipbflag2 ] ; then
          logger -s -t "gluon-wificheck" -p 5 "2nd time no wifi neighbours, rebooting!"
          sleep 3
          # don't reboot during the first hour
          [ $(cat /proc/uptime | sed 's/\..*//g') -gt 3600 ] || reboot -f
         else
          logger -s -t "gluon-wificheck" -p 5 "still no wifi neighbours."
          echo 1>/tmp/wifipbflag2
         fi
       else
        logger -s -t "gluon-wificheck" -p 5 "lost wifi neighbours."
        echo 1>/tmp/wifipbflag
       fi
    else
     if [ -f /tmp/wifipbflag ] ; then
       rm /tmp/wifipbflag
      fi
     if [ -f /tmp/wifipbflag2 ] ; then
       rm /tmp/wifipbflag2
      fi
    fi
   fi
 fi
