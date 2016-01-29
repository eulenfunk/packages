gluon wifi neighbor check
=========================

this script looks for wifi mesh neighbors. 
If at least 2 meshneibours are found once (after boot), the script is set into trigger mode. 

then the absence of neighbors in the wifimesh will alert the node. and if the absence is still present the next minute, the node is rebootet. 

GLUON_SITE_FEEDS="weeklyreboot"<br>
PACKAGES_WIFICHECK_REPO=https://github.com/eulenfunk/gluon-weeklyreboot.git<br>
PACKAGES_WIFICHECK_COMMIT=<br>
PACKAGES_WIFICHECK_BRANCH=master<br>

With this done you can add the package gluon-weeklyreboot to your site.mk

This branch of the skript contains the weeklyreboot version for the current master based on openwrt chaos-calmer (upcoming 2016.1)
