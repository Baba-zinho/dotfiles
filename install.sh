#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════
#  dotfiles « Feels » — installation complète en une commande
#  openSUSE Tumbleweed Slowroll · SwayFX · Waybar · kitty · wofi · Nemo
#  fish + Starship · mako · eww · palette tirée du fond d'écran
#
#  Sur une installation neuve (sans bureau), connecté en TTY :
#    curl -fsSL https://raw.githubusercontent.com/Baba-zinho/dotfiles/main/install.sh | bash
#  Ou depuis le dépôt déjà cloné :
#    cd ~/dotfiles && ./install.sh
#
#  Relançable sans risque : ce qui est déjà fait est sauté.
#  À lancer SANS sudo (il le demande lui-même quand il en a besoin).
# ═══════════════════════════════════════════════════════════════════════
set -euo pipefail

REPO_URL="${DOTFILES_REPO:-https://github.com/Baba-zinho/dotfiles.git}"
DOTDIR="${DOTFILES_DIR:-$HOME/dotfiles}"

vert()  { printf '\033[1;32m%s\033[0m\n' "$*"; }
jaune() { printf '\033[1;33m%s\033[0m\n' "$*"; }
etape() { printf '\n\033[1;34m══ %s ══\033[0m\n' "$*"; }

# ── 0. Vérifications ────────────────────────────────────────────────────
if [ "$(id -u)" -eq 0 ]; then
    echo "✘ Ne lance pas ce script avec sudo ni en root : lance-le avec ton utilisateur."
    exit 1
fi
grep -qi opensuse /etc/os-release || { echo "✘ Ce script est prévu pour openSUSE."; exit 1; }
sudo -v

# ── 1. Récupérer le dépôt (si lancé via curl) ───────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-.}")" 2>/dev/null && pwd || echo "")"
if [ -z "$SCRIPT_DIR" ] || [ ! -d "$SCRIPT_DIR/config" ]; then
    etape "Récupération du dépôt dotfiles"
    sudo zypper --non-interactive install git
    if [ -d "$DOTDIR/.git" ]; then
        git -C "$DOTDIR" pull --ff-only
    else
        git clone "$REPO_URL" "$DOTDIR"
    fi
    exec bash "$DOTDIR/install.sh" </dev/tty
fi
DOTDIR="$SCRIPT_DIR"
cd "$DOTDIR"

# ── 2. Droits : tout ce qui est dans ~ doit t'appartenir ───────────────
etape "Droits sur ton dossier personnel"
mkdir -p "$HOME/.config" "$HOME/.local/share"
sudo chown -R "$USER:" "$HOME/.config" "$HOME/.local" "$DOTDIR"

# ── 3. Dépôts communautaires pour SwayFX + SceneFX ─────────────────────
etape "Dépôts SwayFX / SceneFX"
if grep -qi slowroll /etc/os-release; then DISTRO=openSUSE_Slowroll; else DISTRO=openSUSE_Tumbleweed; fi
ajouter_depot() {
    local alias=$1 chemin=$2
    if ! zypper lr "$alias" >/dev/null 2>&1; then
        sudo zypper --non-interactive addrepo -f \
            "https://download.opensuse.org/repositories/${chemin}/${DISTRO}/" "$alias"
    fi
}
ajouter_depot home_neifua               "home:/neifua"
ajouter_depot home_BRavens_Compositors  "home:/BRavens:/Compositors"
sudo zypper --non-interactive --gpg-auto-import-keys refresh

# ── 4. Paquets ──────────────────────────────────────────────────────────
etape "SwayFX"
# --from : SwayFX vient de home:neifua (sa bibliothèque SceneFX de BRavens est tirée automatiquement)
# --force-resolution : remplace le paquet « sway » s'il est installé
sudo zypper --non-interactive install --force-resolution --from home_neifua swayfx

etape "Paquets"
PAQUETS=(
    # Bureau
    waybar kitty wofi nemo eww mako libnotify-tools
    swaybg swayidle swaylock grim slurp swappy wl-clipboard
    brightnessctl playerctl pavucontrol polkit-gnome
    xdg-desktop-portal-wlr xdg-desktop-portal-gtk xdg-user-dirs
    # Socle absent d'une installation minimale
    pipewire pipewire-pulseaudio wireplumber
    NetworkManager NetworkManager-connection-editor bluez
    Mesa-dri intel-media-driver
    # Thème
    papirus-icon-theme adwaita-icon-theme
    # Shell
    fish starship zoxide fzf eza bat
    # Outils pour ce script
    git curl unzip tar xz meson
)
if ! sudo zypper --non-interactive install "${PAQUETS[@]}"; then
    jaune "⚠ Installation groupée refusée : on réessaie un par un"
    for p in "${PAQUETS[@]}"; do
        sudo zypper --non-interactive install "$p" >/dev/null 2>&1 \
            && echo "  ✔ $p" || jaune "  ⚠ $p introuvable — ignoré"
    done
fi

# ── 5. Ce qui n'est pas dans les dépôts ────────────────────────────────
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT

etape "Police Maple Mono NF"
if ! fc-list | grep -i "Maple Mono NF" >/dev/null; then
    curl -fL -o "$TMP/maple.zip" \
        https://github.com/subframe7536/maple-font/releases/latest/download/MapleMono-NF-unhinted.zip
    mkdir -p "$HOME/.local/share/fonts/MapleMono-NF"
    unzip -oq "$TMP/maple.zip" -d "$HOME/.local/share/fonts/MapleMono-NF"
    fc-cache -f
fi
vert "✔ Maple Mono NF"

etape "Thème GTK adw-gtk3"
if [ ! -d /usr/share/themes/adw-gtk3-dark ] && [ ! -d "$HOME/.local/share/themes/adw-gtk3-dark" ]; then
    if ! sudo zypper --non-interactive install adw-gtk3 >/dev/null 2>&1; then
        url=$(curl -fsSL https://api.github.com/repos/lassekongo83/adw-gtk3/releases/latest \
              | grep -o 'https://[^"]*adw-gtk3v[^"]*\.tar\.xz' | sed -n 1p)
        mkdir -p "$HOME/.local/share/themes"
        curl -fL "$url" | tar -xJ -C "$HOME/.local/share/themes"
    fi
fi
vert "✔ adw-gtk3-dark"

etape "Icônes symboliques de Nemo (xsi-)"
if ! compgen -G '/usr/share/icons/hicolor/scalable/actions/xsi-*' >/dev/null; then
    git clone --depth 1 https://github.com/xapp-project/xapp-symbolic-icons "$TMP/xsi"
    ( cd "$TMP/xsi" && meson setup build --prefix=/usr && sudo meson install -C build )
    sudo gtk-update-icon-cache -f /usr/share/icons/hicolor
fi
vert "✔ icônes xsi"

etape "Dossiers Papirus en vert"
curl -fsSL -o "$TMP/papirus-folders" \
    https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/master/papirus-folders
chmod +x "$TMP/papirus-folders"
sudo "$TMP/papirus-folders" -C green --theme Papirus-Dark || jaune "⚠ recoloration ignorée"

etape "Curseur Bibata"
if [ ! -d "$HOME/.local/share/icons/Bibata-Modern-Classic" ]; then
    mkdir -p "$HOME/.local/share/icons"
    curl -fL https://github.com/ful1e5/Bibata_Cursor/releases/latest/download/Bibata-Modern-Classic.tar.xz \
        | tar -xJ -C "$HOME/.local/share/icons"
fi
mkdir -p "$HOME/.local/share/icons/default"
printf '[Icon Theme]\nInherits=Bibata-Modern-Classic\n' > "$HOME/.local/share/icons/default/index.theme"
vert "✔ Bibata-Modern-Classic"

# ── 6. Configs : un lien par élément de config/ ───────────────────────
etape "Liens des configs"
SAUVEGARDE="$HOME/.config-avant-dotfiles/$(date +%Y%m%d-%H%M%S)"
lier() {
    # lier <source dans le dépôt> <emplacement dans ~>
    local src=$1 dst=$2
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then return 0; fi
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        mkdir -p "$SAUVEGARDE/$(dirname "${dst#"$HOME/"}")"
        mv "$dst" "$SAUVEGARDE/${dst#"$HOME/"}"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo "  ✔ ${dst#"$HOME/"}"
}
for element in "$DOTDIR"/config/*; do
    lier "$element" "$HOME/.config/$(basename "$element")"
done
lier "$DOTDIR/wallpapers" "$HOME/.local/share/wallpapers"
if [ -d "$SAUVEGARDE" ]; then jaune "Anciennes configs mises de côté dans : $SAUVEGARDE"; fi
chmod +x "$DOTDIR"/config/eww/scripts/*.sh

# ── 7. Réglages système et session ─────────────────────────────────────
etape "Services et session"
sudo systemctl enable --now NetworkManager >/dev/null 2>&1 || true
sudo systemctl enable bluetooth >/dev/null 2>&1 || true
systemctl --user enable pipewire pipewire-pulse wireplumber >/dev/null 2>&1 || true
xdg-user-dirs-update || true
mkdir -p "$HOME/Images/Captures"

# Sway démarre tout seul après connexion sur le TTY1 (bash reste le shell de connexion)
if ! grep -q "exec sway" "$HOME/.bash_profile" 2>/dev/null; then
    cat >> "$HOME/.bash_profile" <<'EOF'

# Lance Sway automatiquement en se connectant sur tty1
if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec sway
fi
EOF
fi

# ── 8. Fin ─────────────────────────────────────────────────────────────
etape "Terminé"
vert "✔ Tout est installé."
echo "  • Redémarre (sudo reboot) puis connecte-toi sur le TTY1 : Sway se lance tout seul."
echo "  • Tes configs dans ~/.config sont des liens vers $DOTDIR/config :"
echo "    modifie-les normalement, puis « dsave » dans fish pour les envoyer sur GitHub."
