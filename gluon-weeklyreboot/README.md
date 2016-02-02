weekly reboot
=============

this script basically reboots a note onece a week on friday night at a random point between 3h15 and 6h AM. 


Create a file "modules" with the following content in your ./gluon/site/ directory:

GLUON_SITE_FEEDS="eulenfunk"<br>
PACKAGES_EULENFUNK_REPO=https://github.com/eulenfunk/packages.git<br>
PACKAGES_EULENFUNK_COMMIT=/missing/<br>
PACKAGES_EULENFUNK_BRANCH=chaos-calmer<br>

With this done you can add the package *gluon-weeklyreboot* to your site.mk

This branch of the skript contains the weeklyreboot version for the current master based on openwrt chaos-calmer (upcoming 2016.1)
