#!/usr/bin/env bash
# ~/.config/eww/scripts/musique.sh
# Suit le lecteur en cours (playerctl) et sort une ligne JSON à chaque changement :
#   {"statut":"Playing","artiste":"…","titre":"…"}
# Les guillemets et antislashs des titres sont échappés pour garder un JSON valide.

esc() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

vide='{"statut":"","artiste":"","titre":""}'
echo "$vide"

playerctl --follow metadata --format $'{{status}}\t{{artist}}\t{{title}}' 2>/dev/null |
while IFS=$'\t' read -r statut artiste titre; do
    if [ -z "$titre" ]; then
        echo "$vide"
    else
        printf '{"statut":"%s","artiste":"%s","titre":"%s"}\n' \
            "$(esc "$statut")" "$(esc "$artiste")" "$(esc "$titre")"
    fi
done
