#!/bin/sh
radio0=$(uci get wireless.radio0) 2>/dev/null
if [ "$?" -eq 0 ] ; then
  mesh0='/tmp/wifi_mesh0_mesh'
  mesh0gone='/tmp/wifi_mesh0_mesh_gone'
  upgrade_started='/tmp/autoupdate.lock'
  [ -f $upgrade_started ] && exit
  r0mesh=$(uci get wireless.mesh_radio0.disabled) 2>/dev/null
  r1mesh=$(uci get wireless.mesh_radio1.disabled) 2>/dev/null
  r0ibss=$(uci get wireless.ibss_radio0.disabled) 2>/dev/null
  r1ibss=$(uci get wireless.ibss_radio1.disabled) 2>/dev/null
  if [ $r0mesh = '0' ] | [ $r0mesh = '0' ] | [ $r0mesh = '0' ] | [ $r0mesh = '0' ] ; then
    batctl o | grep -q "ibss0\|mesh0"
    if [ $? == 0 ] ; then
      #found wifi-mesh on mesh0*
      touch $mesh0
      rm $mesh0gone.* 2>/dev/null
    else
      if [ -f $mesh0 ]; then
        if [ -f $mesh0gone.3 ]; then
          [ -f $upgrade_started ] && exit
          securereboot
          exit
        elif [  -f $mesh0gone.2 ]; then
          touch $mesh0gone.3
        elif [  -f $mesh0gone.1 ]; then
          touch $mesh0gone.2
        else
          touch $mesh0gone.1
        fi
      fi
    fi
  fi
fi 

