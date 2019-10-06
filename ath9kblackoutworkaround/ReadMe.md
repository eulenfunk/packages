eulenfunk-ath9k-blackout-workaround
===================================

forked from https://git.ffho.net/FreifunkHochstift/ffho-packages/src/v2017.1.x/ffho/ffho-ath9k-blackout-workaround
(GPL Karten Böddeker)

In order to avoid further WiFi-Blackouts that *might* be caused by buggy ath9k,
we try to detect problems and restart the wifi.

site.conf
---------

**ath9k_workaround.blackout_wait:**
- minimum delay in minutes to detect a possible blackout as blackout

**ath9k_workaround.reset_wait:**
- minimum delay in minutes between reset

**ath9k_workaround.step_size**
- execute the cronjob each x minutes

### example
```lua
{
  ath9k_workaround = {
    blackout_wait = 720,
    reset_wait = 1440,
    step_size = 10,
  },
  ...
},
```
