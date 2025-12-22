eulenfunk--mt7915-backlog
=============  
ported from ffac-mt7915-backlog

source: https://github.com/ffac/gluon-packages/blob/ffac-mt7915-backlog/ffac-mt7915-backlog/files/lib/gluon/mt7915/restart-wifi-if-backlog-filled.sh

This package restarts wifi if the mt7915-backlog has more than 50 packets in the queue on ramips-mt7621
and mediatek-filogic. It's meant as a hotfix for the mcu timeout issue:
https://github.com/freifunk-gluon/gluon/issues/3154

Create a file `modules` with the following content in your `./gluon/site/`
directory and add these lines: 

```
GLUON_SITE_FEEDS="eulenfunk"
PACKAGES_COMMUNITY_REPO=https://github.com/eulenfunk/packages.git
PACKAGES_COMMUNITY_COMMIT=*/missing/*
PACKAGES_COMMUNITY_BRANCH=v2023.2.x
```

Now you can add the package `eulenfunk-mt7915-backlog` to your site.mk
(`*/missing/*` has to be replaced by the github-commit-ID of the version you
want to use, you have to pick it manually.)

Further info on the issue this tries to prevent from happening:
When the backlog queue fill up, the device does not respond over wlan reliably.
Sometimes, the backlog is cleared after a few minutes,
but in busy environments this takes far too long and gets the system into an unresponsive state.
Pings are not responend, traffic is stalled.

I experienced these issues on various Zyxel NWA 55 AXE as well as on an Acer Vero W6M in busy environments.
This happens on 5GHz as well as on 2.4GHz ifaces, depending on where the higher load is.
Other devices with mt7915 like COVR-X1860 and DAP-X1860 are not affected on openwrt-24.10

Also see https://github.com/openwrt/mt76/issues/1009
