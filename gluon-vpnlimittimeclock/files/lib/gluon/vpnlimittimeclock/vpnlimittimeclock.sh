#! /bin/sh

#turn on the bandwidth limiter on meshvpn link by schedule. 
#

sleep 37 # this is a hack
logger -s -t "gluon-vpnlimittimeclock" -p 5 "vpnlimittimeclock invoked"

vpnlimitoff="/tmp/vpnlimit.off"
vpnlimiton="/tmp/vpnlimit.on"

CurrentTime="$(date +%k%M)"
CurrentDayOfWeek="$(date +%w)"
#echo "CurrentTime is $CurrentTime, CurrentDayOfWeek is $CurrentDayOfWeek"

dummy=$(uci get simple-tc.mesh_vpn.enabled)
if [ $? -eq 0 ]; then
  dummy=$(uci get simple-tc.mesh_vpn.clock_on)
  if [ $? -eq 0 ]; then
    vpnlimiton=$(uci get simple-tc.mesh_vpn.clock_on)
    vpnlimitoff=$(uci get simple-tc.mesh_vpn.clock_off)
    if ( [ ${#vpnlimiton} -eq 4 ] ) && ( [ ${#vpnlimitoff} -eq 4 ] ) ; then
      if ( ( ( [ $vpnlimiton -le $vpnlimitoff ] ) && ( ( [ $CurrentTime -ge $vpnlimiton ] ) && ( [ $CurrentTime -le $vpnlimitoff ] ) ) ) \
        || ( ( [ $vpnlimiton -ge $vpnlimitoff ] ) && ( ( [ $CurrentTime -ge $vpnlimiton ] ) || ( [ $CurrentTime -le $vpnlimitoff ] ) ) ) ) ; then
        if [ $(uci get simple-tc.mesh_vpn.enabled) -eq 0 ] ; then
          uci set simple-tc.mesh_vpn.enabled=1
          logger -s -t "gluon-vpnlimittimeclock" -p 5 "VPN-bandwidthlimit aktiviert"
          /etc/init.d/network restart
          rm $vpnlimitoff &>/dev/null
          echo 1> $vpnlimiton
         fi
       else
        if [ $(uci get simple-tc.mesh_vpn.enabled) -eq 1 ] ; then
          uci set simple-tc.mesh_vpn.enabled=0   
          logger -s -t "gluon-vpnlimittimeclock" -p 5 "VPN-bandwidthlimit deaktiviert"
          /etc/init.d/network restart
          rm $vpnlimiton &>/dev/null
          echo 1> $vpnlimitoff
         fi
      fi
     else
      logger -s -t "gluon-vpnlimittimeclock" -p 5 "simple-tc.mesh_vpn.clock_on or simple-tc.mesh_vpn.clock_off not set correctly to hhmm format."
     fi
   fi
 fi

#eof
