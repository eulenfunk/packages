#!/usr/bin/lua

site = require("gluon.site")
local uci = require("simple-uci").cursor()

--- wrapper for calling systemcommands
function cmd(_command)
        local f = io.popen(_command)
        local l = f:read("*a")
        f:close()
        return l
end

--- first of all, get the right 2.4GHz wifi interface
local interface24 = false
local interface50 = false
if uci:get('wireless', 'radio0', 'hwmode') then
        chanR0 = uci:get('wireless', 'radio0', 'channel')
        if chanR0 < '16' then
                interface24 = 'radio0'
                chanR1 = uci:get('wireless', 'radio1', 'channel')
                if chanR1 > '15' then
                        interface50 = 'radio1'
                end
        elseif chanR0 > '15'  then
                interface50 = 'radio0'
                chanR1 = uci:get('wireless', 'radio1', 'channel')
                if chanR1 < '16' then
                        interface24 = 'radio1'
                end
        else
                os.exit(0) -- something went wrong
        end
end

--- 2.4G
--- determine country
channel = uci:get('wireless', interface24, 'channel')
if channel == '13' then
        country = 'US'
elseif channel == '12' then
        country = 'DE'
else
        country = 'US'
end

--- set values (1st pass)
uci:set('wireless', interface24, 'country', country)
uci:set('wireless', interface24, 'htmode', 'HT20')
uci:save('wireless')
uci:commit('wireless')
t = cmd('sleep 2')
t = cmd('/sbin/wifi')
t = cmd('sleep 8')

--- get maximum available power and step
t = cmd('iwinfo ' .. interface24 .. ' txpowerlist | tail -n 2 | head -n 1 | awk \'{print $1}\'')
maximumTxPowerDb = string.gsub(t, "\n", "")
maximumTxPowerDb = tonumber(maximumTxPowerDb)

if maximumTxPowerDb < 30 then
        t = cmd('iwinfo ' .. interface24 .. ' txpowerlist | wc -l')
        maximumTxPower = string.gsub(t, "\n", "")
        maximumTxPower = tonumber(maximumTxPower)-1
else
        t = cmd('iwinfo ' .. interface24 .. ' txpowerlist | grep -n "19 dBm" | cut -f1 -d\':\'')
        maximumTxPower = string.gsub(t, "\n", "")
        maximumTxPower = tonumber(maximumTxPower)-1
end

--- set values (2nd pass)
uci:set('wireless', interface24, 'txpower', maximumTxPower)
uci:save('wireless')
uci:commit('wireless')

--- 5G
if interface50 == 'radio0' or interface50 == 'radio1' then
	uci:set('wireless', interface50, 'country', country)
        VHT = cmd('iwinfo ' .. interface50 .. ' htmodelist|xargs -n 1|grep VHT40')
	if string.match(VHT, 'VHT40') then
		uci:set('wireless', interface50, 'htmode', 'VHT40')
	else 
		uci:set('wireless', interface50, 'htmode', 'HT20')
	end
	--- set values (1st pass)
	uci:save('wireless')
	uci:commit('wireless')
	t = cmd('sleep 2')
	t = cmd('/sbin/wifi')
	t = cmd('sleep 8')
	--- get maximum available power and step
	t = cmd('iwinfo ' .. interface50 .. ' txpowerlist | tail -n 2 | head -n 1 | awk \'{print $1}\'')
	maximumTxPowerDb = string.gsub(t, "\n", "")
	maximumTxPowerDb = tonumber(maximumTxPowerDb)
	if maximumTxPowerDb < 30 then
	        t = cmd('iwinfo ' .. interface50 .. ' txpowerlist | wc -l')
        	maximumTxPower = string.gsub(t, "\n", "")
	        maximumTxPower = tonumber(maximumTxPower)-1
	else
	        t = cmd('iwinfo ' .. interface50 .. ' txpowerlist | grep -n "19 dBm" | cut -f1 -d\':\'')
	        maximumTxPower = string.gsub(t, "\n", "")
	        maximumTxPower = tonumber(maximumTxPower)-1
	end
	--- set values (2nd pass)
	uci:set('wireless', interface50, 'txpower', maximumTxPower)
	uci:save('wireless')
	uci:commit('wireless')
end

t = cmd('sleep 2')
t = cmd('/sbin/wifi')
t = cmd('sleep 3')

