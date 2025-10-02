#!/bin/bash

packages="
  stow wget terminator zsh git gcc clang valgrind gdb build-essential 
  curl zip unzip pciutils tree luarocks xsel xclip bear make
"
modules="font nvim zsh"

DOTFILES_DIR="$HOME/.dotfiles"

install_packages() {
  for package in $packages; do
    if ! dpkg -s "$package" >/dev/null 2>&1; then
      echo "Trying to install $package"
      sudo apt update && sudo apt install -y "$package"
    else
      echo "$package already installed"
    fi
  done
}

install_oh_my_zsh() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  else
    echo "oh-my-zsh already installed"
  fi
}

install_powerlevel10k() {
  if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "Installing powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
  else
    echo "powerlevel10k already installed"
  fi
}

set_zsh_default() {
  if [ "$SHELL" != "$(command -v zsh)" ]; then
    echo "Setting zsh as the default shell..."
    chsh -s "$(command -v zsh)"
  else
    echo "zsh is already the default shell"
  fi
}

create_link() {
    cd "$DOTFILES_DIR"
    for mod in $modules_classic; do
        stow "$mod"
    done
}

if command -v apt >/dev/null 2>&1; then
	install_packages
	install_oh_my_zsh
	install_powerlevel10k
	create_link
	set_zsh_default
else
	echo "OS or packages installer not Support"
	exit 1
fi
