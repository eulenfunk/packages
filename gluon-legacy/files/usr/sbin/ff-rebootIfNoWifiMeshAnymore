mesh0='/tmp/wifi_mesh0_mesh'
mesh0gone='/tmp/wifi_mesh0_mesh_gone'

batctl o | grep -q "mesh0"
if [ $? == 0 ] ; then
  #found wifi-mesh on mesh0*
  touch $mesh0
  [ -f $mesh0gone ] && rm $mesh0gone
else
  if [ -f $mesh0 ]; then
    [ -f $mesh0gone ] && reboot -f ; exit
    touch $mesh0gone
  fi
fi
