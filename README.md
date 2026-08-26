# .dotfiles

Config **portable Debian 12 / 13** : zsh, Neovim, Terminator.

Le dépôt se clone dans `~/.dotfiles` (ou lance `install.sh` depuis la racine du repo — Stow utilise l’emplacement du script).

## Install

```sh
git clone <this-repo> ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh
./install.sh
```

Puis ouvre un nouveau terminal (ou `exec zsh`).

Status seulement :

```sh
./install.sh check
```

L’installeur :

- installe les paquets apt (zsh, terminator, stow, fuse, clangd, ripgrep, …)
- installe oh-my-zsh, powerlevel10k, zsh-autosuggestions
- stow `font`, `nvim`, `zsh`, `terminator` (les fichiers existants sont sauvegardés en `*.bak.<timestamp>`)
- télécharge l’AppImage Neovim et la lie dans `~/.local/bin/nvim`
- rafraîchit le cache des polices
- passe zsh en shell de login (`chsh`)

## Spécifique à une machine

Ne mets **pas** les PATH / outils d’un poste dans ce repo. Utilise :

```sh
~/.zshrc.local
```

Exemple :

```sh
export PATH="$PATH:$HOME/Bin/jdk-21/bin"
export PATH="$HOME/.grok/bin:$PATH"
```

## Layout

```
font/          Nerd Font (Terminator + p10k)
nvim/          config NvChad v2.5
zsh/           .zshrc .p10k.zsh aliases/fonctions
terminator/    config telle quelle (non retouchée)
AppImg/        binaire Neovim (gitignoré, téléchargé par install.sh)
```

## Notes

- Neovim vient de l’AppImage officielle (le paquet `neovim` de Debian 12 est trop vieux pour NvChad).
- `~/.local/bin` est en tête de `PATH` ; `vi` / `v` aliasent `nvim` s’il existe.
- Le paquet Debian s’appelle `bat`, le binaire `batcat` (aliasé en `bat`).
