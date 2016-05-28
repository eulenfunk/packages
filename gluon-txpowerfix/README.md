Gluon TXPowerFix
================

In Chaos Calmer (Gluon v2016.1+) the limitations of the DE regulatory domain 
have changed to an unrealistically low value. 

This script removes the excessive limitations of the DE regulatory domain 
from the 2.4 GHz iface by setting the country code to BO and sets the HT-Mode 
to HT40 unless otherwise specified in your site.conf. It also removes the 
802.1b-standard to gain airtime. 

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
+----------------+----------------------------+--------+
|option          |possible values             |default |
+----------------+----------------------------+--------+
|htmode          |HT20, HT40+, HT40-, HT40    |HT40    |
|ac_htmode       |VHT20, VHT40, VHT80, VHT160 |VHT80   |
|htmode_noscan   |true, false                 |true    |
|purge_txpower   |true, false                 |false   |
|disable_ac_mesh |true, false                 |false   |
|disable_ac_ibss |true, false                 |false   |
+----------------+----------------------------+--------+
```
