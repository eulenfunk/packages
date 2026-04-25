#! /bin/sh
valuecheck ()
# this checks for multiple problems on the same IF, tries to resolve, or reboots as last resort
{
  logstring=$logstring" "$linkname"."$check":"$wert
  if [ ! -f /tmp/linkcheck.$linkname.$check.inhood ] ; then
    if [ "$wert" -gt 1 ] ; then #minimum 2 neighbors
      echo $(date)>/tmp/linkcheck.$linkname.$check.inhood
     fi
   else # .inhood file present
    if [ "$wert" -lt 1 ] ; then # link disappeared!
      if [ -f /tmp/linkcheck.$linkname.$check.linkpb1 ] ; then
        if [ -f /tmp/linkcheck.$linkname.$check.linkpb2 ] ; then
          if [ -f /tmp/linkcheck.$linkname.$check.linkpb3 ] ; then
            logger -s -t "eulenfunk-linkcheck" -p 5 "lost neighbors 4th: $linkname.$check, rebooting!"
            sleep 10
            upgrade_started='/tmp/autoupdate.lock'
            [ -f $upgrade_started ] && exit
            reboot -f
           fi
          # 3nd time failure
          logger -s -t "eulenfunk-linkcheck" -p 5 "lost neighbors 3rd: $linkname.$check, wifi restart"
          echo $(date)>/tmp/linkcheck.$linkname.$check.linkpb3
          wifi down
          killall hostapd >/dev/null 2>&1
          rm -f /var/run/wifi-*.pid  >/dev/null 2>&1
          wifi config
          wifi up
          sleep 15
         fi
        logger -s -t "eulenfunk-linkcheck" -p 5 "lost neighbours 2nd:$linkname.$check"
        echo $(date)>/tmp/linkcheck.$linkname.$check.linkpb2
       else #linkpb1 existiert noch nicht, anlegen!
        logger -s -t "eulenfunk-linkcheck" -p 5 "lost neighbours 1st:$linkname.$check"
        echo $(date)>/tmp/linkcheck.$linkname.$check.linkpb1
      fi
    else #links reappeard, cleaning all pb-files
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

#do not run run while node is firmware flashing
upgrade_started='/tmp/autoupdate.lock'
[ -f $upgrade_started ] && exit

# 1) running over existing batman-interface, looking for direct neighbors
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

# 2) running over wifimesh-interfaces, looking for other SSIDs on the same wifi via iwscan lowpri

# do not run on mediatek (filogic...) devices, since it seems to break meshlinks.
gluontarget=$(cat /etc/openwrt_release|grep DISTRIB_TARGET|cut -d"=" -f2|tr -d \'|cut -d/ -f1)
if [ "$gluontarget" != "mediatek" ]; then
  checks=""
  linksexist=""
  links="wireless.mesh_radio0 wireless.batmesh_radio0 wireless.mesh_radio1 wireless.batmesh_radio1 wireless.mesh_radio2 wireless.batmesh_radio2 wireless.client_radio0 wireless.client_radio1 wireless.client_radio2"
  for link in $links; do
    linkname=$(uci get $link.ifname 2>/dev/null)
    if [ ! -z "$linkname" ] ; then
      linksexist="$linksexist $link"
     fi
  done
  # alte scans wegr??umen
  rm /tmp/linkcheck.iwscan.* 2>/dev/null
  for linkexist in $linksexist; do
    linkname=$(uci get $linkexist.ifname)
    iwfile=/tmp/linkcheck.iwscan.$(uci get $linkexist.device)
    if [ ! -f $iwfile ] ; then
      sleep 4
      iw dev $linkname scan lowpri passive > $iwfile
      sleep 4
     fi
    bsses=$(cat $iwfile|grep "BSS .*:.*:.*:.*:.*:.*(on.*)"|wc -l)
    checks="bsses"
##   looking for BSSIDs with the name of the wifimesh
#    unset bssid
#    bssid=$(uci get $linkexist.mesh_id 2>/dev/null)
#    if [ -z "$bssid" ] ; then
#      bssid=$(uci get $linkexist.ssid)
#     fi
#    wifimeshneighbors=$(cat $iwfile|grep $bssid|wc -l)
#    checks="wifimeshneighbors bsses"
    for check in $checks; do
      wert=$(eval echo \$$check)
      valuecheck $check
     done
   done
 fi

# 3) check for disappearing batman-interfaces
  wirebatlinks="mesh-vpn primary0 br-mesh_other br-mesh_lan br-mesh_wan br-wan br-lan br-mesh_other1 br-mesh_other2 br-mesh_other3 br-mesh_other4 br-mesh_other5"
  wifibatlinks="mesh0 mesh1 mesh2 mesh3"

  # inventory of bat-interfaces, from all possible sources, probably unneccesary
  batinterfaces2=$(batctl n|tail -n +3|awk '{print $1}'|sort|uniq)
  batinterfaces1=$(batctl if|cut -d: -f1|sort|uniq)
  batinterfaces3=$(echo "$batinterfaces1 $batinterfaces2")
  batinterfaces=$(for l in $batinterfaces3; do echo $l; done|sort|uniq)
#  echo batinterfaces $batinterfaces

  # create flag files in /tmp
  for batinterface in $batinterfaces; do
    echo $(date)>/tmp/linkcheck.batinterface.$batinterface.up
   done
  # get all previously seen interfaces by flag files
  for batupfiles in "/tmp/linkcheck.batinterface.*.up"; do
    :
   done
  # check if all prviously seen are in current list
  for batups in $batupfiles; do
    batifupf=$(echo $batups|cut -d. -f3)
    if [[ "$batinterfaces" =~ "$batifupf" ]]; then
      wert=2
     else
      wert=0
      logger -s -t "eulenfunk-linkcheck" -p 5 batman interface $batifupf gone missing
     fi
    linkname=batinterfaces
    check=$batifupf
    valuecheck $check
   done

  # check if all previously seen interface, are there batman (inhood-file) and did they disappear later?
  batmanoriginatorsfile="/tmp/linkcheck.batmanoriginators.list"
  batctl o|tail -n +3>$batmanoriginatorsfile
  for batups in $batupfiles; do
    batifupf=$(echo $batups|cut -d. -f3)
    if [[ ! "$wifibatlinks" =~ "$batifupf" ]]; then    # do not check for wifimesh links as check/reboot condition!
      echo check if by file: $batifupf # individually previsously seen file
      bators=$(cat $batmanoriginatorsfile|grep $batifupf|wc -l)
      logger -s -t "eulenfunk-linkcheck" -p 5 on bat if $batifupf : $bators originators
      wert=$bators
      linkname=batman.originators
      check=$batifupf
      valuecheck $check
     fi
   done

## 4) check for disappearing bridge interfaces
#
# get current bridges
  bridgeslist=$(brctl show |cut -f1|sort -u|sed '/^\s*$/d'|grep -v "bridge name")
  # create flag files in /tmp
  for bridgename in $bridgeslist; do
    echo $(date)>/tmp/linkcheck.bridge.$bridgename.up
    interfaces=$(brctl show $bridgename|sed -e 's/\t/                     /g'|cut -c 100-|sed -e 's/ //g'|tail -n +2)
    for interface in $interfaces; do
      echo $(date)>/tmp/linkcheck.bridgeif.$bridgename.if+$interface+up
     done
   done

  # get all previously seen bridges by flag files
  for upbridgesf in "/tmp/linkcheck.bridge.*.up"; do
    :
#    echo file # $upbridgesf
   done
#  echo upbridgesf $upbridgesf
  # check if all prviously seen are in current list
  for upbridgef in $upbridgesf; do
    upbridge=$(echo $upbridgef|cut -d. -f3)
    echo check if by file: $upbridge # individually previsously seen file
    if [[ "$bridgeslist" =~ "$upbridge"   ]]; then
       wert=2
#       echo $upbridge is golden
      else
       wert=0
       logger -s -t "eulenfunk-linkcheck" -p 5 bridge $upbridge gone missing
      fi
     linkname=bridgeinterfaces
     check=$upbridge
     valuecheck $check
     for interfacesf in "/tmp/linkcheck.bridgeif.$upbridge.if+*+up"; do
       :
      done
#     echo file  $interfacesf
     for interfacef in $interfacesf; do
       interfaced=$(echo $interfacef|cut -d+ -f2)
#       echo testing $upbridge:$interfaced
       interfaces=$(brctl show $upbridge|sed -e 's/\t/                     /g'|cut -c 100-|sed -e 's/ //g'|tail -n +2)
#       echo $interfaces
       if [[ "$interfaces" =~ "$interfaced" ]]; then
         wert=2
#         echo $upbridge:$interfaced is golden
        else
         wert=0
         logger -s -t "eulenfunk-linkcheck" -p 5 bridge-member $upbridge:$interfaced gone missing
        fi
        linkname=bridgeinterfaceports
        check=$upbridge:$interfaced
        valuecheck $check
      done
   done
logger -s -t "eulenfunk-linkcheck" -p 5 $logstring
