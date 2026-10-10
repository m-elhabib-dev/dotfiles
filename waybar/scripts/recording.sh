#!/usr/bin/env bash
# Waybar custom module: shows REC + elapsed time while wf-recorder runs; empty (hidden) otherwise.
pid=$(pgrep -x wf-recorder | head -1)
if [ -z "$pid" ]; then
    echo '{"text":"","class":"idle"}'
    exit 0
fi
s=$(ps -o etimes= -p "$pid" | tr -d ' ')
t=$(printf '%02d:%02d' $((s / 60)) $((s % 60)))
printf '{"text":"\xef\x84\x91 REC %s <span color=\\"#6c7086\\">|</span>","class":"recording","tooltip":"Recording... click to stop"}\n' "$t"
