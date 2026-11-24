#!/usr/bin/env bash
# publier.sh — envoie ce dossier sur GitHub (dépôt public « dotfiles »), en une commande.
# À lancer une seule fois, depuis la VM, SANS sudo :  ~/dotfiles/publier.sh
# Ensuite, pour sauvegarder tes modifs : « dsave » dans fish.
set -euo pipefail
cd "$(dirname "$0")"

# 1) Outils
command -v gh >/dev/null || sudo zypper --non-interactive install gh
command -v git >/dev/null || sudo zypper --non-interactive install git

# 2) Connexion à GitHub (ouvre le navigateur et affiche un code à recopier)
if ! gh auth status >/dev/null 2>&1; then
    gh auth login --hostname github.com --git-protocol https --web
fi
gh auth setup-git
login=$(gh api user -q .login)
echo "✔ Connecté à GitHub en tant que $login"

# 3) Ton pseudo dans la commande d'installation
sed -i "s/TON_PSEUDO/$login/g" install.sh README.md

# 4) Identité git (adresse « noreply » de GitHub : ton vrai mail reste privé)
git config --global user.name  >/dev/null || git config --global user.name  "$login"
git config --global user.email >/dev/null || git config --global user.email "$login@users.noreply.github.com"

# 5) Premier commit et envoi
[ -d .git ] || git init -b main
git add -A
git commit -m "Config Feels" >/dev/null 2>&1 || echo "(rien de nouveau à enregistrer)"
if gh repo view "$login/dotfiles" >/dev/null 2>&1; then
    git remote get-url origin >/dev/null 2>&1 || git remote add origin "https://github.com/$login/dotfiles.git"
    git push -u origin main
else
    gh repo create dotfiles --public --source=. --remote=origin --push
fi

echo
echo "✔ Publié : https://github.com/$login/dotfiles"
echo "Sur ton PC (openSUSE Slowroll fraîchement installé), une seule commande :"
echo
echo "  curl -fsSL https://raw.githubusercontent.com/$login/dotfiles/main/install.sh | bash"
echo
