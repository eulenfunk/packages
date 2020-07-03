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
        chanR0 = tonumber(uci:get('wireless', 'radio0', 'channel'))
        if chanR0 < 16 then
                interface24 = 'radio0'
                chanR1 = tonumber(uci:get('wireless', 'radio1', 'channel'))
                if chanR1 then
                        if chanR1 > 15 then
                               interface50 = 'radio1'
                        end
                end
        elseif chanR0 > 15  then
                interface50 = 'radio0'
                chanR1 = tonumber(uci:get('wireless', 'radio1', 'channel'))
                if chanR1 then
                        if chanR1 < 16 then
                                interface24 = 'radio1'
                        end
                end
        else
                os.exit(0) -- something went wrong
        end
end

--- switch channel if needed

if interface24 then
        channel24 = uci:get('wireless', interface24, 'channel')
        if channel24 == '13' then
                newchannel24 = '9' 
                uci:set('wireless', interface24, 'channel', newchannel24)
	        uci:save('wireless')
        	uci:commit('wireless')
        end
end
