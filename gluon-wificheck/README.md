gluon wifi neighbor check
=========================

this script looks for wifi mesh neighbors. 
If at least 2 meshneibours are found once (after boot), the script is set into trigger mode. 

then the absence of neighbors in the wifimesh will alert the node. and if the absence is still present the next minute, the node is rebootet. 

Create a file "modules" with the following content in your ./gluon/site/ directory:

GLUON_SITE_FEEDS="eulenfunk"<br>
PACKAGES_EULENFUNK_REPO=https://github.com/eulenfunk/packages.git<br>
PACKAGES_EULENFUNK_COMMIT=*/missing/*<br>
PACKAGES_EULENFUNK_BRANCH=chaos-calmer<br>

With this done you can add the package *gluon-wificheck* to your site.mk

This branch of the script contains the wificheck version for the current master based on openwrt chaos-calmer (gluon 2016.1), but should work with 2015.1.x as well. (untested)
