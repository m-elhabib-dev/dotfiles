#!/usr/bin/env bash

if nvidia-smi &>/dev/null; then
    nvidia-smi --query-gpu=memory.used,temperature.gpu --format=csv,noheader,nounits |
        awk -F', ' '{printf "GPU %sM/%s° |", $1, $2}'
fi