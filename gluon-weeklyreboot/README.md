weekly reboot
=============

this script basically reboots a node once a week on thursday nights at a random point between 3h15 and 6h AM. 

Create a file "modules" with the following content in your ./gluon/site/ directory:

GLUON_SITE_FEEDS="eulenfunk"<br>
PACKAGES_EULENFUNK_REPO=https://github.com/eulenfunk/packages.git<br>
PACKAGES_EULENFUNK_COMMIT=*/missing/*<br>
PACKAGES_EULENFUNK_BRANCH=chaos-calmer<br>

With this in your "modules" done you can add the package *gluon-weeklyreboot* to your site.mk<br>
<small>(/*missing/* has to be replaced by the github-commit-ID of the version you want to use, you have to pick it manually.)</small>

This branch of the skript contains the weeklyreboot version for the current gluon release 2016.1, based on openwrt chaos-calmer.
