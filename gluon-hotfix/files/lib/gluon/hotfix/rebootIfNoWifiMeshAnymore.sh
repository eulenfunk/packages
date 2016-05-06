#!/bin/sh

mesh0='/tmp/wifi_mesh0_mesh'
mesh0gone='/tmp/wifi_mesh0_mesh_gone'
upgrade_started='/tmp/autoupdate.lock'

[ -f $upgrade_started ] && exit

r0mesh=$(uci get wireless.mesh_radio0.disabled)
r1mesh=$(uci get wireless.mesh_radio1.disabled)
r0ibss=$(uci get wireless.ibss_radio0.disabled)
r1ibss=$(uci get wireless.ibss_radio1.disabled)

if [ $r0mesh = '0' ] | [ $r0mesh = '0' ] | [ $r0mesh = '0' ] | [ $r0mesh = '0' ] ; then
  wireless.mesh_radio0.disabled='0'
  batctl o | grep -q "ibss0\|mesh0"
  if [ $? == 0 ] ; then
    #found wifi-mesh on mesh0*
    touch $mesh0
    [ -f $mesh0gone ] && rm $mesh0gone
  else
    if [ -f $mesh0 ]; then
      if [ -f $mesh0gone ]; then
        [ -f $upgrade_started ] && exit
        securereboot
        exit
      fi
      touch $mesh0gone
    fi
  fi
fi