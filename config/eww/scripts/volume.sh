#!/usr/bin/env bash
# Envoie {"niveau":42,"muet":false} à chaque changement de son (instantané, sans sondage)
emit() {
    v=$(LC_ALL=C pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | grep -o '[0-9]*%' | head -n1 | tr -d '%')
    m=$(LC_ALL=C pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null | grep -q yes && echo true || echo false)
    printf '{"niveau":%s,"muet":%s}\n' "${v:-0}" "$m"
}
emit
LC_ALL=C pactl subscribe | grep --line-buffered -E "'change' on (sink|server)" | while read -r _; do emit; done
