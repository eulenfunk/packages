gluon txpowerfix
================

In OpenWRT Chaos Calmer the offsets used to calculate txpowers were changed.
For numerous reasons the values are wrongly calculated or just
over-optimistic, as a result, the available "on air" is for many devices
lower than the goal of 20dBm/100mW. 
by consequence meshlinks tend to degrade "from green to red" when upgrading
from gluon 2015.x to 2016.x

This script removes the limitations of the DE region from the 2.4 GHz iface 
by setting the country code to BO. It also sets the HT-Mode to HT40 unless 
otherwise specified in your site.conf. Finally, it removes the 802.1b-standard
to gain airtime. 

To use the script in your firmware:

<br>
GLUON_SITE_FEEDS="eulenfunk"<br>
PACKAGES_EULENFUNK_REPO=https://github.com/eulenfunk/packages.git<br>
PACKAGES_EULENFUNK_COMMIT=*/missing/*<br>
PACKAGES_EULENFUNK_BRANCH=master<br>

With this done you can add the package *ffgl-txpowerfix* to your site.mk
