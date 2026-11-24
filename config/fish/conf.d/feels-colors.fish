# ~/.config/fish/conf.d/feels-colors.fish
# Coloration syntaxique de fish — palette « Feels » (mêmes hex que sway/palette.conf)
# En "set -g" (et non -U) : tout vit dans ce fichier, donc versionnable avec tes dotfiles.

set -g fish_color_normal          dfe8ee
set -g fish_color_command         4cc274            # commande valide → vert grenouille
set -g fish_color_error           e5654a            # commande inconnue → rouille
set -g fish_color_keyword         e39a8a            # if, for, function…
set -g fish_color_param           a8bcc8
set -g fish_color_option          9bc8ab            # --options
set -g fish_color_quote           f2c46b            # "chaînes"
set -g fish_color_redirection     4fa8bd            # > | <
set -g fish_color_operator        4fa8bd            # * ~ $
set -g fish_color_end             e8894f            # ; && ||
set -g fish_color_escape          e39a8a            # \n \t
set -g fish_color_comment         5f7a8c --italics
set -g fish_color_autosuggestion  5f7a8c            # suggestion grisée
set -g fish_color_valid_path      --underline
set -g fish_color_cancel          e5654a
set -g fish_color_cwd             7393ea
set -g fish_color_user            4cc274
set -g fish_color_host            7393ea
set -g fish_color_selection       --background=1f4a5c
set -g fish_color_search_match    --background=1a2f42
set -g fish_color_history_current --bold

# Menu de complétion (Tab)
set -g fish_pager_color_prefix              4cc274 --bold --underline
set -g fish_pager_color_completion          dfe8ee
set -g fish_pager_color_description         5f7a8c --italics
set -g fish_pager_color_progress            0b0d1a --background=4cc274
set -g fish_pager_color_selected_background --background=1a2f42
