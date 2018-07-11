# Eulenfunk Packages

This branch works for gluon 2018.1.x.

### gluon-aptimeclock

Turn on/off client AP by cron. A script that will turn off the client AP network
during definable times via UCI. See [](gluon-aptimeclock/README.md)

### gluon-banner

Banner file replacement, Some nice messages on login and more aliases set.

### gluon-hotfix

Hotfix-collection-VFN: Reboot if no Wifi clients or if no Gateway connection.

### gluon-linkcheck

WIFI-Neighborcheck. See [](gluon-linkcheck/README.md)

### gluon-quickfix

Reboot under certain conditions (loss of mesh neighbours, broken client wifi,
unsuccessful anycast ping). See [](gluon-quickfix/README.md)

### gluon-ssid-changer

Changes the SSID to an Offline-SSID so clients don't connect to an offline WiFi.

This is a direct copy of https://github.com/Freifunk-Nord/gluon-ssid-changer 
branch 2018.1.x 

### gluon-txpowerfix

Fixes txpower on some wifi nodes since OpenWrt chaos calmer by setting the 
country code to 00/BO so it can be set to higher values than the incorrectly
configured german code allows. See [](gluon-txpowerfix/README.md)

### gluon-vpnlimittimeclock

Turn on/off the bandwitdth limit for vpn-usage by cron schedule. See
[](gluon-vpnlimittimeclock/README.md)

### gluon-weeklyreboot

weekly reboot sheduled on thursday morning. See [](gluon-weeklyreboot/README.md)

### gluon-wificheck

WIFI-Neighborcheck. restarts wifi no wifi mesh neighbours are seen after
initially there were at lease two neighbours. See [](gluon-wificheck/README.md)
