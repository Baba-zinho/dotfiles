# ~/.config/fish/config.fish  —  fish · palette « Feels »
# Les couleurs de la coloration syntaxique sont dans conf.d/feels-colors.fish
# (fish charge automatiquement tout ce qui est dans conf.d/ avant ce fichier)

if status is-interactive
    # Pas de message d'accueil (on mettra fastfetch ici plus tard)
    set -g fish_greeting

    # ── Prompt ──
    starship init fish | source

    # ── Outils (activés seulement s'ils sont installés) ──
    # zoxide : « z proj » saute vers le dossier le plus fréquent contenant « proj »
    type -q zoxide; and zoxide init fish | source

    # fzf : Ctrl+R historique, Ctrl+T fichiers, Alt+C dossiers
    if type -q fzf
        fzf --fish | source
        set -gx FZF_DEFAULT_OPTS "\
--height=40% --layout=reverse --border=rounded --info=inline \
--color=bg+:#1a2f42,bg:-1,fg:#a8bcc8,fg+:#dfe8ee,hl:#4cc274,hl+:#4cc274 \
--color=border:#2a4556,prompt:#4cc274,pointer:#e8894f,marker:#e39a8a \
--color=info:#5f7a8c,spinner:#4fa8bd,header:#7393ea"
    end

    # eza : ls moderne avec icônes (utilise les couleurs du terminal → palette Feels)
    if type -q eza
        alias ls 'eza --icons --group-directories-first'
        alias ll 'eza -l --icons --group-directories-first --git'
        alias la 'eza -la --icons --group-directories-first --git'
        alias lt 'eza --tree --level=2 --icons'
    end

    # bat : cat avec coloration ; le thème « ansi » reprend les couleurs du terminal
    if type -q bat
        set -gx BAT_THEME ansi
        alias cat 'bat --paging=never --style=plain'
    end

    # ── Abréviations (tapées puis développées à l'espace : tu vois la vraie commande) ──
    # Sur Tumbleweed/Slowroll, on met à jour avec « dup », jamais « up »
    abbr -a maj  'sudo zypper ref && sudo zypper dup'
    abbr -a zin  'sudo zypper in'
    abbr -a zrm  'sudo zypper rm'
    abbr -a zse  'zypper se'
    abbr -a zinfo 'zypper info'

    abbr -a g    git
    abbr -a gs   'git status'
    abbr -a ga   'git add'
    abbr -a gc   'git commit -m'
    abbr -a gp   'git push'
    abbr -a gl   'git log --oneline --graph --decorate -15'

    abbr -a rsway 'swaymsg reload'

    # Dotfiles : aller dans le dépôt / tout sauvegarder sur GitHub
    abbr -a dots  'cd ~/dotfiles'
    abbr -a dsave 'git -C ~/dotfiles add -A && git -C ~/dotfiles commit -m "maj config" && git -C ~/dotfiles push'
    abbr -a ..   'cd ..'
    abbr -a ...  'cd ../..'
end

# Variables d'environnement (valables aussi en mode non interactif)
set -gx EDITOR nano          # on passera à nvim quand on fera Neovim
fish_add_path -g ~/.local/bin
set -e SSH_ASKPASS
