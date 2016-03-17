gluon txpowerfix
================

up to OpenWRT BarrierBreaker, the wifi stack did take automatically the
highest available txpower. 

introduction with ChaosCalmer, OpenWRT does take into account the antenna
gain, stored as value in the ART partition of the SPI flash. 
for numerous reasons the values are wrong calculated or just
over-optimistic, as a result, the available "on air" is for many devices
lower than the goal of 20dBm/100mW. 
by consequence meshlinks tend to degrade "from green to red" when upgrading
from gluon 2015.x to 2016.x

this script will run it's worker task at first boot after installation/sysupgrade. 
(after execution it will be cleared from the rc.local-execution.)

In full operation of 2.4GHz radio it will obtain the txpower-list which is
in place "real" with the current setting of channel, hwmode, htmode etc. 
then the highest available setting is stored in /etc/config/wireless as
txpower value. 

(pull requests wellcome)


To use the script in your firmware:

<br>
GLUON_SITE_FEEDS="eulenfunk"<br>
PACKAGES_EULENFUNK_REPO=https://github.com/eulenfunk/packages.git<br>
PACKAGES_EULENFUNK_COMMIT=*/missing/*<br>
PACKAGES_EULENFUNK_BRANCH=master<br>

With this done you can add the package *gluon-txpowerfix* to your site.mk
