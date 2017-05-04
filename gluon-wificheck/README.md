gluon wifi neighbour check
==========================

This script looks for wifi mesh neighbours. 
If at least 2 mesh neighbours are found once (after boot), the script is set into trigger mode. 

Then the absence of neighbours in the wifi-mesh will alert the node. And if the absence is still present the next minute, the node will reboot. 

### How to use this module in your firmware

Create a file `modules` with the following content in your `./gluon/site/` directory:

```
GLUON_SITE_FEEDS="eulenfunk"
PACKAGES_EULENFUNK_REPO=https://github.com/eulenfunk/packages.git
# add the latest commit ID of this repository here
PACKAGES_EULENFUNK_COMMIT=1951b97db14ca7b098db76cd6c64363a14de3903
PACKAGES_EULENFUNK_BRANCH=chaos-calmer
```

With this done you can add the package *gluon-wificheck* to your site.mk

This branch of the script contains the wificheck version for the gluon branch `v2016.1.x` based on openwrt chaos-calmer, but should work with 2015.1.x as well. (untested)

Beware: this relies on IBSS/adhoc mode, not compatible with 802.11s-mesh yet.
