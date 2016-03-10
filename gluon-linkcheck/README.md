gluon lan and wifi neighbour check
==================================

this script looks for wifi and lan mesh neighbours. 

If at least 2 meshneibours are found once (after boot) on a link, the script is set into trigger mode for this interface.

(take a look in /tmp/linkcheck.$linktype.$interface for current status.)

when in trigger mode the absence of neighbours in the wifimesh will alert the node. and if the absence is still present the next interval (5 minutes) and the next interval still, the node is rebootet. 

Create a file "modules" with the following content in your ./gluon/site/ directory:

GLUON_SITE_FEEDS="eulenfunk"<br>
PACKAGES_EULENFUNK_REPO=https://github.com/eulenfunk/packages.git<br>
PACKAGES_EULENFUNK_COMMIT=*/missing/*<br>
PACKAGES_EULENFUNK_BRANCH=chaos-calmer<br>

With this done you can add the package *gluon-linkcheck* to your site.mk

This branch of the script contains the linkcheck version for the current openwrt chaos-calmer (gluon 2016.1.x), but should work with 2015.1.x as well. (untested)
Beware: this relies on IBSS/adhoc mode, not compatible with 802.11s-mesh yet.
