weekly reboot
=============

this script basically reboots a note onece a week on friday night at a random point between 3h15 and 6h AM. 


Create a file "modules" with the following content in your <a href="https://github.com/eulenfunk/gluon-weeklyreboot"> site directory:</a>

GLUON_SITE_FEEDS="weeklyreboot"<br>
PACKAGES_WEEKLYREBOOT_REPO=https://github.com/eulenfunk/gluon-weeklyreboot.git<br>
PACKAGES_WEEKLYREBOOT_COMMIT=<br>
PACKAGES_WEEKLYREBOOT_BRANCH=master<br>

With this done you can add the package gluon-weeklyreboot to your site.mk

This branch of the skript contains the weeklyreboot version for the current master based on openwrt chaos-calmer (upcoming 2016.1)
