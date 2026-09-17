#!/bin/bash
temp=$(awk '{printf "%d", $1/1000}' /sys/class/thermal/thermal_zone7/temp)

read -r _ user nice system idle iowait irq softirq steal _ _ < <(grep '^cpu ' /proc/stat)
prev_total=$((user + nice + system + idle + iowait + irq + softirq + steal))
prev_idle=$((idle + iowait))

sleep 0.5

read -r _ user nice system idle iowait irq softirq steal _ _ < <(grep '^cpu ' /proc/stat)
total=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle=$((idle + iowait))

delta=$((total - prev_total))
delta_idle=$((idle - prev_idle))
usage=$(((delta - delta_idle) * 100 / delta))

printf 'CPU %d%%/%d°\n' "$usage" "$temp"
