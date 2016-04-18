gluon ap switch toggle
=========================

this script will turn off the client AP network during nighttimes (or during daytimes!)
please set the UCI values accordingling for radio0 (usually 2,4GHz) and radio1 (usually 5GHz)

Format: hhmm (0815 for 08h15 AM, 2045 for 8h45 PM)<br>
if on < off - ClientAP working during daytime<br>
if off < on - ClientAP working during nighttime<br>
<br>
example: <br>
uci set wireless.radio0.client_clock_on=0815<br>
uci set wireless.radio0.client_clock_off=2045<br>
uci set wireless.radio1.client_clock_on=0730<br>
uci set wireless.radio1.client_clock_off=1935<br>
<br>
GLUON_SITE_FEEDS="eulenfunk"<br>
PACKAGES_EULENFUNK_REPO=https://github.com/eulenfunk/packages.git<br>
PACKAGES_EULENFUNK_COMMIT=*/missing/*<br>
PACKAGES_EULENFUNK_BRANCH=master<br>

With this done you can add the package *gluon-aptimeclock* to your site.mk
