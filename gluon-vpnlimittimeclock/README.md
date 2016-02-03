gluon VPN-WAN bandwithlimit switch toggle
=========================================

this script will turn on the bandwidth-throttle for meshvpn link during nighttimes (or during daytimes!)
please set the UCI values accordingling

Format: hhmm (0815 for 08h15 AM, 2045 for 8h45 PM)<br>
if on < off - vpnlimit throttle during daytimes<br>
if off < on - vpnlimit throttle during nighttimes<br>
<br>
example:<br>
uci set simple-tc.mesh_vpn.clock_on=0810<br>
uci set simple-tc.mesh_vpn.clock_off=1915<br>
<br>
GLUON_SITE_FEEDS="eulenfunk"<br>
PACKAGES_EULENFUNK_REPO=https://github.com/eulenfunk/packages.git<br>
PACKAGES_EULENFUNK_COMMIT=*/missing/*<br>
PACKAGES_EULENFUNK_BRANCH=master<br>

With this done you can add the package *gluon-vpnlimittimeclock* to your site.mk
