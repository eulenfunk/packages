Gluon TXPowerFix
================

In Chaos Calmer (Gluon v2016.1+) the limitations of the DE regulatory domain 
have changed and are much stricter now. 

If configured to do so this script can remove the new limitations of the 
DE regulatory domain from the 2.4 GHz iface by setting the country code to BO 
and setting the HT-Mode to HT40 unless otherwise specified in your site.conf. 
It also removes the 802.1b-standard to gain airtime. 

To use the script in your firmware:

```
GLUON_SITE_FEEDS="eulenfunk"
PACKAGES_EULENFUNK_REPO=https://github.com/eulenfunk/packages.git
PACKAGES_EULENFUNK_COMMIT=*/missing/*
PACKAGES_EULENFUNK_BRANCH=master
```

With this done you can add the package *gluon-txpowerfix* to your site.mk.

The package (re)introduces serveral new and old options in the wifi sections:

```
+-------------------+----------------------------+-----------------+
|option             |possible values             |default          |
+-------------------+----------------------------+-----------------+
|country (2.4 only) |DE, 00, BO, (...)           |unchanged        |
|htmode             |HT20, HT40+, HT40-, HT40    |HT20             |
|ac_htmode          |HT20, HT40+, HT40-, HT40, \ |HT20             |
|                   |VHT20, VHT40, VHT80, VHT160 |                 |
|htmode_noscan      |true, false                 |false            |
|purge_txpower      |true, false                 |false            |
|mesh.ac_disabled   |true, false                 |false            |
|ibss.ac_disabled   |true, false                 |false            |
+-------------------+----------------------------+-----------------+
```

To archieve similar results as in Barrier Breaker, change:
- country for 2.4 to BO
- htmode to HT40(+/-)
- purge_txpower to 1 if you have used other txpowerfix-packages before

If you want to use the Wifi AC capabilities of some devices you can 
disable the ac ibss and set ac_htmode to VHT80. 
