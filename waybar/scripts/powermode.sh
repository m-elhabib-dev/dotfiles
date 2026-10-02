#!/usr/bin/env bash
# Waybar custom module: shows current power mode (set by ~/.local/bin/powermode).

no_turbo=$(cat /sys/devices/system/cpu/intel_pstate/no_turbo 2>/dev/null)
epp=$(cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference 2>/dev/null)
profile=$(tuned-adm active 2>/dev/null | sed 's/^Current active profile: //')
gpu=$(envycontrol --query 2>/dev/null)

if [ "$no_turbo" = 1 ] && [ "$epp" = power ]; then
    class=battery
    text=$'\uf06c BAT'
elif [ "$no_turbo" = 0 ] && [ "$epp" != power ]; then
    class=performance
    text=$'\uf0e7 PERF'
else
    class=custom
    text=$'\uf128 MIX'
fi

tooltip="Profile: $profile\\nTurbo: $([ "$no_turbo" = 1 ] && echo off || echo on)\\nEPP: $epp\\nGPU: $gpu"

printf '{"text": "%s", "class": "%s", "tooltip": "%s"}\n' "$text" "$class" "$tooltip"
