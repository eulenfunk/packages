# eulenfunk-quickfix

This package will add a cronjob that fixes some problems that rarely occur, but are easy to work around. 

### Safety checks:
To be sure, that the script is not disturbing the start and update process:
- if autoupdater is running, `exit`
- if the router started less than 5 minutes ago, `exit`

### Workarounds
- check if we have lost any neighbours, `iw dev $DEV scan`
- if dropbear is not running, reboot (probably ram was full, so more services might've crashed)
- reboot if there was a kernel (batman) error

### Healthcheck
- (don't do anything the first 50 minutes after router is started, uptimecheck)
- batman-adv eadly wounded situation (ksoftirqd/mem alloc error) -> reboot
- atherosdriver deadly wounded situations (mem alloc errors) -> reboot
- too many l2tp tunneldigger instances running (3+, means: restarting without killing old zombies, otherwiese hours of slow death)
- br-client interface not initialized with any valid IPv6 (router is just meshing, but will not be able so show statuspage or get updates)
- respondd died or dropbear not running: If this happens, something very strange happended to the system. -> reboot
- iw on wifi hangs (does not terminate, this is a servere atheros bug) -> detect and reboot.
- iw scan with lowpri, to force the wifi to wake up (just in case of strange powermanagement behavoir)
- check for radio neigbors and report them to log, to have some stats in the logread, in case no map with history/grafana etc in reach

Manual installation
===================

If you don't have this package in your firmware, you can still install it
manually on a node:

```
ROUTER_IP='your:node::ip6'
LOGIN="root@[$ROUTER_IP]"
git clone https://github.com/eulenfunk/packages/ -b v2018.1.x
cd eulenfunk-hotfix/
scp -r files/* $LOGIN:/
ssh $ROUTER_IP "/etc/init.d/micrond reload;"
```
