# dotfiles « Feels »

SwayFX · Waybar · kitty · wofi · Nemo · fish + Starship · mako · eww, sur openSUSE Tumbleweed **Slowroll**.
Palette tirée du fond d'écran : bleu nuit `#0e1726`, vert grenouille `#4cc274`, bleu `#7393ea`, orange `#e8894f`.

## Installer sur un PC neuf

1. Installer openSUSE **Slowroll** sans environnement de bureau (Btrfs + snapshots par défaut).
2. Se connecter sur l'écran texte, puis :

```bash
curl -fsSL https://raw.githubusercontent.com/Baba-zinho/dotfiles/main/install.sh | bash
```

3. `sudo reboot`, se reconnecter sur le TTY1 : Sway démarre tout seul.

Le script ne pose pas de question à part ton mot de passe, et on peut le relancer sans risque.
Les anciens fichiers de config éventuels sont mis de côté dans `~/.config-avant-dotfiles/`.

## Ce que fait `install.sh`

- ajoute les dépôts `home:neifua` (SwayFX) et `home:BRavens:Compositors` (SceneFX) ;
- installe SwayFX, les applis, le son PipeWire, NetworkManager, les pilotes Intel, fish, Starship… ;
- télécharge ce qui n'est pas dans les dépôts : police Maple Mono NF, thème adw-gtk3, icônes xsi de Nemo, curseur Bibata, dossiers Papirus verts ;
- relie chaque élément de `config/` dans `~/.config` (liens symboliques) ;
- active les services et le démarrage automatique de Sway sur le TTY1.

## Organisation

Tout est dans **`config/`**, rangé exactement comme `~/.config` :

```
dotfiles/
├── install.sh      installe tout (une commande)
├── publier.sh      envoie le dossier sur GitHub (une fois)
├── config/         sway  waybar  kitty  wofi  swappy  mako  eww  fish
│                   gtk-3.0  gtk-4.0  starship.toml
└── wallpapers/     feels.png
```

`install.sh` remplace chaque élément de `~/.config` par un lien vers `config/`.

## Modifier et sauvegarder

Les fichiers de `~/.config` **sont** ceux du dépôt (liens) : modifie-les normalement, puis dans fish :

- `dsave` : enregistre et envoie tout sur GitHub ;
- `dots` : va dans `~/dotfiles`.

Pour changer une couleur partout, modifie le même code hex dans `sway/palette.conf`, `waybar/style.css`,
`wofi/style.css`, `kitty.conf`, `mako/config`, `gtk-*/gtk.css`, `eww.scss`, `feels-colors.fish` et `starship.toml`.

## Raccourcis

| Raccourci | Action |
| --- | --- |
| Meta+Entrée | Terminal |
| Meta+D | Lanceur (rappuyer pour fermer) |
| Meta+E | Fichiers (Nemo) |
| Meta+P | Panneau eww (ou clic sur l'horloge) |
| Meta+Q | Fermer la fenêtre |
| Meta+F | Plein écran |
| Meta+Maj+Espace | Flottante / rangée |
| Meta+Maj+C | Recharger la config |
| Meta+Maj+E | Quitter Sway |
| Meta+H/J/K/L ou flèches | Changer de fenêtre (+Maj : déplacer) |
| Meta+A | Conteneur parent |
| Meta+1…0 | Bureau 1 à 10 (+Maj : y envoyer la fenêtre) |
| Meta+Maj+S | Capture d'une zone à annoter |
| Impr | Capture de l'écran |
| Meta+N / Meta+Maj+N | Fermer la dernière / toutes les notifications |
| Meta + clic gauche / droit | Déplacer / redimensionner à la souris |

## Mettre à jour le système

Toujours `sudo zypper dup` (abréviation `maj` dans fish), jamais `zypper up`.
