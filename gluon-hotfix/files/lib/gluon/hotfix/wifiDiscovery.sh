#!/bin/sh
radio0=$(uci get wireless.radio0) 2>/dev/null
if [ "$?" -eq 0 ] ; then
  iw dev client0 scan lowpri passive >/dev/null 2>&1 || iw dev client0 scan >/dev/null 2>&1
  sleep 2
  iw dev client1 scan lowpri passive >/dev/null 2>&1 || iw dev client1 scan >/dev/null 2>&1
fi
