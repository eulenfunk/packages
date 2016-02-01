#! /bin/sh
mname=$(uci get wireless.ibss_radio0.ifname) || mname=$(uci get wireless.mesh_radio0.ifname)
if [ -z "$mname" ] ; then
  exit 0
 else
  echo radio: $mname
  mesh=$(batctl o|grep $mname|wc -l)
  wmesh=$(iw dev $mname scan|grep $mname|wc -l)
  echo meshneighbours: $mesh wifineighbours: $wmesh
  if [ ! -f /tmp/noisland ] ; then
    if [ "$mwesh" != "0" ] ; then
      echo 1>/tmp/noisland
    fi
   else
    if [ "$wmesh" == "0" ] ; then
      if [ -f /tmp/wifipbflag ] ; then
        reboot -f
       else
        echo 1>/tmp/wifipbflag
       fi
    else
     if [ -f /tmp/wifipbflag ] ; then
       rm /tmp/wifipbflag
      fi
    fi
   fi
 fi
