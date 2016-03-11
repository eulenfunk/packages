gluon lan and wifi neighbour check
==================================

this script looks for wifi and lan mesh neighbours. 
goal is to detect crashed/flapping drivers on wifi and eth, even on hw level.
After loss of all neighbors on an interface (where there have been 2 or more in the past), the box is rechecking 3 times (every 5 minutes) and if an interface stays "an island" without not at least one neighbour (where 2 or had been seen since last boot): the box is reboot. 

How triggering an interface works:
If at least 2 meshneibours are found once (after boot) on a link, the script is set into trigger mode for this interface.

(take a look in /tmp/linkcheck.$linktype.$interface for current status.)

when in trigger mode the absence of neighbours in the wifimesh will alert the node. and if the absence is still present the next interval (5 minutes) and the next interval still, the node is rebootet. 
on batctl-o table the "island detection" will be only triggered if the respective link is up. 
in other words: if the lan-link (eth wan/lan) is down ("really disconnected cable"), the reset will not perform. it only detects for "link up, but no partners visible in the link".

example:  (wifi turned off "on purpose")

    Fri Mar 11 11:25:07 2016 user.notice gluon-linkcheck: batadv.br-wan:4 batadv.ibss0:0 ibss0.neighbours:2 ibss0.wadhoc:13
    Fri Mar 11 11:30:07 2016 user.notice gluon-linkcheck: batadv.br-wan:4 batadv.ibss0:0 ibss0.neighbours:2 ibss0.wadhoc:13
    Fri Mar 11 11:35:07 2016 user.notice gluon-linkcheck: batadv.br-wan:4 batadv.ibss0:0 ibss0.neighbours:2 ibss0.wadhoc:11
    Fri Mar 11 11:40:05 2016 user.notice gluon-linkcheck: lost neighbours ibss0.neighbours.
    Fri Mar 11 11:40:05 2016 user.notice gluon-linkcheck: lost neighbours ibss0.wadhoc.
    Fri Mar 11 11:40:05 2016 user.notice gluon-linkcheck: batadv.br-wan:4 ibss0.neighbours:0 ibss0.wadhoc:0
    Fri Mar 11 11:45:06 2016 user.notice gluon-linkcheck: still no neighbours ibss0.neighbours, wifi restart
    Fri Mar 11 11:45:06 2016 user.notice gluon-linkcheck: still no neighbours ibss0.wadhoc, wifi restart
    Fri Mar 11 11:45:06 2016 user.notice gluon-linkcheck: batadv.br-wan:4 ibss0.neighbours:0 ibss0.wadhoc:0
    Fri Mar 11 11:50:05 2016 user.notice gluon-linkcheck: 2nd time no neighbours ibss0.neighbours, rebooting!
    packet_write_wait: Connection to fda0:747e:ab29:9375:6666:b3ff:fede:a7e4 port 22: Broken pipe


Create a file "modules" with the following content in your ./gluon/site/ directory:

GLUON_SITE_FEEDS="eulenfunk"<br>
PACKAGES_EULENFUNK_REPO=https://github.com/eulenfunk/packages.git<br>
PACKAGES_EULENFUNK_COMMIT=*/missing/*<br>
PACKAGES_EULENFUNK_BRANCH=chaos-calmer<br>

With this done you can add the package *gluon-linkcheck* to your site.mk

This branch of the script contains the linkcheck version for the current openwrt chaos-calmer (gluon 2016.1.x), but should work with 2015.1.x as well. (untested)
Beware: this relies on IBSS/adhoc mode, not compatible with 802.11s-mesh yet.
