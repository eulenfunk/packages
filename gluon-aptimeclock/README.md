gluon ap switch toggle
======================

This script will turn off the client AP network during nighttimes (or during daytimes!)
Please set the UCI values accordingling for radio0 (usually 2,4GHz) and radio1 (usually 5GHz)

```
Format: hhmm (0815 for 08h15 AM, 2045 for 8h45 PM)
if on < off - ClientAP working during daytime
if off < on - ClientAP working during nighttime

example: 
uci set wireless.radio0.client_clock_on=0815
uci set wireless.radio0.client_clock_off=2045
uci set wireless.radio1.client_clock_on=0730
uci set wireless.radio1.client_clock_off=1935

GLUON_SITE_FEEDS="eulenfunk"
PACKAGES_EULENFUNK_REPO=https://github.com/eulenfunk/packages.git
PACKAGES_EULENFUNK_COMMIT=*/missing/*
PACKAGES_EULENFUNK_BRANCH=v2018.1.x
```

With this done you can add the package *gluon-aptimeclock* to your site.mk
