#!/usr/bin/env bash
# Envoie le pourcentage de luminosité dès qu'il change.
# Lecture directe de /sys toutes les 0,2 s (quasi gratuit), sortie seulement si la valeur bouge.
dev=$(ls -d /sys/class/backlight/* 2>/dev/null | head -n1)
[ -z "$dev" ] && { echo 0; exec sleep infinity; }
max=$(cat "$dev/max_brightness")
prev=""
while :; do
    v=$(( $(cat "$dev/brightness") * 100 / max ))
    [ "$v" != "$prev" ] && { echo "$v"; prev=$v; }
    sleep 0.2
done
