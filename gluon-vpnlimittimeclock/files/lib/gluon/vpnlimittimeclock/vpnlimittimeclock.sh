#! /bin/sh

#turn on the bandwidth limiter on meshvpn link by schedule. 
#

logfile="/tmp/vpnlimit.log"
echo "$(date):vpnlimittimeclock invoked" >> $logfile

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
      if ( ( ( [ $vpnlimiton -le $vpnlimitoff ] ) && ( [ $CurrentTime -ge $vpnlimiton ] ) && ( [ $CurrentTime -le $vpnlimitoff ] ) ) || ( ( [ $vpnlimiton -ge $vpnlimitoff ] ) && ( [ $CurrentTime -ge $vpnlimiton ] ) || ( [ $CurrentTime -le $vpnlimitoff ] ) ) ) ; then
        if [ $(uci get simple-tc.mesh_vpn.enabled) -eq 0 ] ; then
          uci set simple-tc.mesh_vpn.enabled=1
          echo "$(date):VPN-bandwidthlimit aktiviert" >> $logfile
          /etc/init.d/network restart
          rm $vpnlimitoff &>/dev/null
          echo 1> $vpnlimiton
         fi
       else
        if [ $(uci get simple-tc.mesh_vpn.enabled) -eq 1 ] ; then
          uci set simple-tc.mesh_vpn.enabled=0   
          echo "$(date):VPN-bandwidthlimit deaktiviert" >> $logfile
          /etc/init.d/network restart
          rm $vpnlimiton &>/dev/null
          echo 1> $vpnlimitoff
         fi
      fi
     else
      echo "simple-tc.mesh_vpn.clock_on or simple-tc.mesh_vpn.clock_off not set correctly to hhmm format."
     fi
   fi
 fi


#case $CurrentDayOfWeek in
#        0)
#                #echo "Sonntag"
#                DoLimit=1
#                ;;
# esac

#eof

