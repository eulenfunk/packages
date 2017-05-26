#!/usr/bin/lua

local nixio = require('nixio')

if not nixio.getenv("EBTABLES_ATOMIC_FILE") then
	print("Error: Refusing to run without EBTABLES_ATOMIC_FILE")
	os.exit(1)
end

os.execute("ebtables -F ARP_LIMIT_DATCHECK")

local popen = io.popen("batctl dc -H")
for line in popen:lines() do
	local t={} ; i=1
	local bar = line:gmatch("(%d+\.%d+\.%d+\.%d+)%s+(%w+:%w+:%w+:%w+:%w+:%w+)")
	local ip, mac

	for a, b in bar do
		ip = a
		mac = b
	end

	os.execute("ebtables -I ARP_LIMIT_DATCHECK -p ARP --arp-ip-dst " .. ip .. " -j mark --mark-or 0x2 --mark-target RETURN")
end
popen:close()
