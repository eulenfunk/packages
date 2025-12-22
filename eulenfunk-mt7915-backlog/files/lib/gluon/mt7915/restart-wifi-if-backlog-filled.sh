#!/bin/sh

for phy in /sys/kernel/debug/ieee80211/phy*; do
    phy_name=$(basename "$phy")
    backlog=$(iw phy "$phy_name" get txq | awk '/Backlog/ {print $2}')
    
    if [ "$backlog" -gt 50 ]; then
        logger -s -t "ffac-mt7915-backlog" -p 5 "$phy_name: Backlog > 50 ($backlog) - restarting wifi"
        wifi
	wifi
    elif [ "$backlog" -gt 0 ]; then
        logger -s -t "ffac-mt7915-backlog" -p 5 "$phy_name: Backlog ($backlog)"
    fi
done

