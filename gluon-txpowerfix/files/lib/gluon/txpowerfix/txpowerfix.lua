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

t = cmd('ip a |grep 192\.168\.1\.1| grep -c br-setup')
setupmode = string.gsub(t, "\n", "")
setupmode = tonumber(setupmode)

--- first of all, get the right 2.4GHz wifi interface
local interface24 = false
local interface50 = false
if uci:get('wireless', 'radio0', 'htmode') then
        chanR0string = uci:get('wireless', 'radio0', 'channel')
        if tonumber( chanR0string ) ~= nil then  --- bypass 'auto'
                chanR0 = tonumber(chanR0string)
        else
                chanR0 = 999
        end
        if chanR0 < 16 then
                interface24 = 'radio0'
	        chanR1string = uci:get('wireless', 'radio1', 'channel')
        	if tonumber( chanR1string ) ~= nil then  --- bypass 'auto'
                	chanR1 = tonumber(chanR1string)
	        else
        	        chanR1 = 999
	        end
                if chanR1 then
                        if chanR1 > 15 then
                               interface50 = 'radio1'
                        end
                end
        elseif chanR0 > 15  then
                interface50 = 'radio0'
	        chanR1string = uci:get('wireless', 'radio1', 'channel')
        	if tonumber( chanR1string ) ~= nil then  --- bypass 'auto'
                	chanR1 = tonumber(chanR1string)
	        else
        	        chanR1 = 999
	        end
                if chanR1 then
                        if chanR1 < 16 then
                                interface24 = 'radio1'
                        end
                end
        else
                os.exit(0) -- something went wrong
        end
end

--- determine country according to 5G

if interface24 then
        channel24 = uci:get('wireless', interface24, 'channel')
        if channel24 == '13' then
                country = 'JP'
        elseif channel24 == '12' then
                country = 'DE'
        else
                country = 'TW'
        end
end

if interface50 then
        channel50 = uci:get('wireless', interface50, 'channel')
        if channel50 == '32' or channel50 == '68' or channel50 == '169' or channel50 == '173' or channel50 == 'auto' or uci:get('gluon', 'wireless', 'outdoor') == '1' then
                country = 'DE'
        elseif channel50 == '138' or channel50 == '142' or channel50 == '144'  then
                country = 'US'
        else
                country = 'TW'
        end
end

if interface24 and interface50 then
        if channel24 == '13' then
                if channel50 == '32' or channel50 == '34' or channel50 == '68' or channel50 == '96' or channel50 == '138' or channel50 == '142' or channel50 == '144' or channel50 == '149' or channel50 == '151' or channel50 == '153' or channel50 == '155' or channel50 == '157' or channel50 == '159' or channel50 == '161' or channel50 == '165' or channel50 == '169' or channel50 == '173' or channel50 == 'auto' then
                        country = 'DE'
                end
        end
end

--- set HT-modes (1st pass)
if interface24 then
	uci:set('wireless', interface24, 'country', country)
	uci:save('wireless')
	uci:commit('wireless')
	t = cmd('/sbin/wifi reconf')
	uci:set('wireless', interface24, 'htmode', 'HT20')
	VHT = cmd('iwinfo ' .. interface24 .. ' htmodelist|xargs -n1|grep -v "+"|grep -e "80\\|40"|tail -n1|tr -d "\n"')
	if string.match(VHT,'HT') or string.match(VHT,'HE') then
		uci:set('wireless', interface24, 'htmode', VHT)
        end
end
if interface50 then
        if interface50 == 'radio0' or interface50 == 'radio1' then
		if channel50 ~= 'auto' and uci:get('gluon', 'wireless', 'outdoor') ~= '1' then  --- do't do if outdoor is enabled
	                uci:set('wireless', interface50, 'country', country)
			uci:save('wireless')
			uci:commit('wireless')
			t = cmd('/sbin/wifi reconf')
        	        VHT = cmd('iwinfo ' .. interface50 .. ' htmodelist|xargs -n1|grep -v "+"|grep -e "80\\|40"|tail -n1|tr -d "\n"')
	                if string.match(VHT,'HT') or string.match(VHT,'HE') then
        	                uci:set('wireless', interface50, 'htmode', VHT)
                	end
                end
	end
end
uci:save('wireless')
uci:commit('wireless')


--- restart with with new ht modes
if interfac24 or interface50 then
	t = cmd('/sbin/wifi reconf')
	t = cmd('sleep 5')
end

--- 2.4G 
if interface24 then
	--- get maximum available power and step for 2.4G
        t = cmd('iwinfo ' .. interface24 .. ' txpowerlist|grep mW|tr -d \'*\'|tail -n 1| awk \'{print $1}\'')
        maximumTxPowerDb = string.gsub(t, "\n", "")
        maximumTxPowerDb = tonumber(maximumTxPowerDb)
	--- set values (2nd pass)
        uci:set('wireless', interface24, 'txpower', maximumTxPowerDb)
end

--- 5G
if interface50 then
 	if channel50 ~= 'auto' and uci:get('gluon', 'wireless', 'outdoor') ~= '1' then  --- do't do if outdoor is enabled
	     	--- get maximum available power and step
      		t = cmd('iwinfo ' .. interface50 .. ' txpowerlist|grep mW|tr -d \'*\'|tail -n 1| awk \'{print $1}\'')
	      	maximumTxPowerDb = string.gsub(t, "\n", "")
       		maximumTxPowerDb = tonumber(maximumTxPowerDb)
	      	--- set values (2nd pass)
	        uci:set('wireless', interface50, 'txpower', maximumTxPowerDb)
	else -- outdoors
        	uci:set('wireless', interface50, 'country', country)
		uci:delete('wireless', interface50, 'txpower')
        end
end

--- restart stuff
if interfac24 or interface50 then
        uci:save('wireless')
        uci:commit('wireless')
	if setupmode  == '0' then --- restart wifi in case of full operation
	        t = cmd('/sbin/wifi reconf')
        end
end
	