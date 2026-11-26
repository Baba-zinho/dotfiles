#!/usr/bin/env bash
# Envoie le pourcentage de luminosité dès qu'il change.
# Tout en commandes internes de bash (aucun programme lancé) : relevé toutes les 0,05 s sans coût.
dev=$(ls -d /sys/class/backlight/* 2>/dev/null | head -n1)
[ -z "$dev" ] && { echo 0; exec sleep infinity; }
read -r max < "$dev/max_brightness"
exec {pause}<> <(:)
prev=""
while :; do
    read -r b < "$dev/brightness"
    v=$(( (b * 100 + max / 2) / max ))
    [[ $v != "$prev" ]] && { echo "$v"; prev=$v; }
    read -rt 0.05 -u "$pause" || true
done
