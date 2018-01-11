#! /bin/sh

#Check if ClientAP shall be limited

sleep 25 # this is a hack
#logger -s -t "gluon-aptimeclock" -p 5 "ClientAP invoked"

ClientRadio0off="/tmp/ClientRadio0.off"
ClientRadio0on="/tmp/ClientRadio0.on"

CurrentTime="$(date +%H%M)"
CurrentDayOfWeek="$(date +%w)"
#echo "CurrentTime is $CurrentTime, CurrentDayOfWeek is $CurrentDayOfWeek"

dummy=$(uci get wireless.client_radio0.disabled)
if [ $? -eq 0 ]; then
  dummy=$(uci get wireless.radio0.client_clock_on)
  if [ $? -eq 0 ]; then
    apclock0on=$(uci get wireless.radio0.client_clock_on)
    apclock0off=$(uci get wireless.radio0.client_clock_off)
    if ( [ ${#apclock0on} -eq 4 ] ) && ( [ ${#apclock0off} -eq 4 ] ) ; then
      if ( ( ( [ $apclock0on -le $apclock0off ] ) && ( ( [ $CurrentTime -le $apclock0on ] ) || ( [ $CurrentTime -ge $apclock0off ] ) ) ) || ( ( [ $apclock0on -ge $apclock0off ] ) && ( ( [ $CurrentTime -le $apclock0on ] ) && ( [ $CurrentTime -ge $apclock0off ] ) ) ) ) ; then
        if [ $(uci get wireless.client_radio0.disabled) -eq 0 ] ; then
          uci set wireless.client_radio0.disabled=1
          logger -s -t "gluon-aptimeclock" -p 5 "APradio0 deaktiviert"
          /sbin/wifi
          rm $ClientRadio0on &>/dev/null
          echo 1> $ClientRadio0off
         fi
       else
        if [ $(uci get wireless.client_radio0.disabled) -eq 1 ] ; then
          uci set wireless.client_radio0.disabled=0
          logger -s -t "gluon-aptimeclock" -p 5 "APradio0 aktiviert"
          /sbin/wifi
          rm $ClientRadio0off &>/dev/null
          echo 1> $ClientRadio0on
        fi
      fi
     else
      logger -s -t "gluon-aptimeclock" -p 5 "wireless.radio0.client_apclock0on or apclock0off not set correctly to hhmm format."
     fi
   fi
 fi

dummy=$(uci get wireless.client_radio1.disabled)
if [ $? -eq 0 ]; then
  dummy=$(uci get wireless.radio1.client_clock_on)
  if [ $? -eq 0 ]; then
    apclock1on=$(uci get wireless.radio1.client_clock_on)
    apclock1off=$(uci get wireless.radio1.client_clock_off)
    if ( [ ${#apclock1on} -eq 4 ] ) && ( [ ${#apclock1off} -eq 4 ] ) ; then
      if ( ( ( [ $apclock1on -le $apclock1off ] ) && ( ( [ $CurrentTime -le $apclock1on ] ) || ( [ $CurrentTime -ge $apclock1off ] ) ) ) || ( ( [ $apclock1on -ge $apclock1off ] ) && ( ( [ $CurrentTime -le $apclock1on ] ) && ( [ $CurrentTime -ge $apclock1off ] ) ) ) ) ; then
        if [ $(uci get wireless.client_radio1.disabled) -eq 0 ] ; then
          uci set wireless.client_radio1.disabled=1
          logger -s -t "gluon-aptimeclock" -p 5 "APradio1 deaktiviert"
          /sbin/wifi
          rm $ClientRadio0on &>/dev/null
          echo 1> $ClientRadio1off
         fi
       else
        if [ $(uci get wireless.client_radio1.disabled) -eq 1 ] ; then
          uci set wireless.client_radio1.disabled=0
          logger -s -t "gluon-aptimeclock" -p 5 "APradio1 aktiviert"
          /sbin/wifi
          rm $ClientRadio0off &>/dev/null
          echo 1> $ClientRadio1on
        fi
      fi
     else
      logger -s -t "gluon-aptimeclock" -p 5 "wireless.radio1.client_apclock1on or .apclock1off not set correctly to hhmm format."
     fi
   fi
 fi

#eof

