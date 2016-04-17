#!/usr/bin/lua

site = require("gluon.site_config")
uci = require('luci.model.uci').cursor()

--- wrapper for calling systemcommands
function cmd(_command)
        local f = io.popen(_command)
        local l = f:read("*a")
        f:close()
        return l
end

--- first of all, get 2.4GHz wifi interface
local interface24 = false
if uci:get('wireless', 'radio0', 'hwmode') then
        hwmode = uci:get('wireless', 'radio0', 'hwmode')
        if hwmode == '11g' then
                interface24 = 'radio0'
        end
end

--- try with radio1 if radio0 seems not the correct interface
if not interface24 and uci:get('wireless', 'radio1', 'hwmode') then
        hwmode = uci:get('wireless', 'radio1', 'hwmode')
        if hwmode == '11g' then
                interface24 = 'radio1'
        end
end
if not interface24 then
        os.exit(0) -- something went wrong
end

--- determine HT-Mode direction
channel = uci:get('wireless', interface24, 'channel')
if channel == '13' then
        htMode = 'HT40-'
elseif channel == '12' then
        htMode = 'HT40-'
elseif channel == '11' then
        htMode = 'HT40-'
else
        htMode = 'HT40+'
end

--- set values (1st pass)
uci:set('wireless', interface24, 'country', 'BO')
uci:set('wireless', interface24, 'htmode', htMode)
uci:set('wireless', interface24, 'channel', channel) 
uci:save('wireless')
uci:commit('wireless')
t = cmd('sleep 2')
t = cmd('/sbin/wifi')
t = cmd('sleep 8')

--- get maximum available power and step
# t = cmd('iwinfo ' .. interface24 .. ' txpowerlist | tail -n 1 | awk \'{print $1}\'')
t = cmd('iwinfo ' .. interface24 .. ' txpowerlist | tail -n 2 | head -n 1 | awk \'{print $1}\'')
maximumTxPowerDb = string.gsub(t, "\n", "")
maximumTxPowerDb = tonumber(maximumTxPowerDb)

if maximumTxPowerDb < 30 then
        t = cmd('iwinfo ' .. interface24 .. ' txpowerlist | wc -l')
        maximumTxPower = string.gsub(t, "\n", "")
#        maximumTxPower = tonumber(maximumTxPower)-1
        maximumTxPower = tonumber(maximumTxPower)-2
else
#       t = cmd('iwinfo ' .. interface24 .. ' txpowerlist | grep -n "20 dBm" | cut -f1 -d\':\'')
        t = cmd('iwinfo ' .. interface24 .. ' txpowerlist | grep -n "19 dBm" | cut -f1 -d\':\'')
        maximumTxPower = string.gsub(t, "\n", "")
        maximumTxPower = tonumber(maximumTxPower)-1
end

--- set values (2nd pass)
uci:set('wireless', interface24, 'txpower', maximumTxPower)
uci:save('wireless')
uci:commit('wireless')

--- apply values
t = cmd('/sbin/wifi')
t = cmd('sleep 2')
