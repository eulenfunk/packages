ath9kblackout
=============

forked from https://git.ffho.net/FreifunkHochstift/ffho-packages/src/v2017.1.x/ffho/ffho-ath9k-blackout-workaround
(GPL Karten Böddeker)

In order to avoid further WiFi-Blackouts that *might* be caused by buggy ath9k,
in this workaround we try to detect problems and restart the wifi.

site.conf
---------

**ath9kblackout.blackoutwait:**
- minimum delay in minutes to detect a possible blackout (eg. no links, noassoc stations) as blackout

**ath9kblackout.resetwait:**
- minimum delay in minutes between reset

**ath9kblackout.stepsize**
- execute the cronjob each x minutes

### example
```lua
{
  ath9kblackout = {
    blackout_wait = 71,
    resetwait = 121,
    stepsize = 10,
  },
  ...
},
```
