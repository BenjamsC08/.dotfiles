#!/bin/bash

packages="
  stow wget terminator zsh git gcc clang valgrind gdb build-essential 
  curl zip unzip pciutils tree luarocks xsel xclip bear make libfuse2t64
"
modules="font nvim zsh terminator"

DOTFILES_DIR="$HOME/.dotfiles"
APPIMG_DIR="$HOME/.dotfiles/AppImg"

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

install_autoSuggestion() {
	if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
		echo "Installing zsh auto-suggestion..."
		git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
	else
		echo "zsh auto-suggestion already installed"
	fi
}

set_zsh_default() {
  if [ "$SHELL" != "$(command -v zsh)" ]; then
    echo "Setting zsh as the default shell..."
    chsh -s "$(command -v zsh)"
	rm -rf "$HOME/.zshrc"
	cd $DOTFILES_DIR
	stow zsh
	
  else
    echo "zsh is already the default shell"
  fi
}

create_link() {
    cd "$DOTFILES_DIR"
    for mod in $modules; do
        stow "$mod" --adopt
    done
}

install_nvim() {
	mkdir -p "$APPIMG_DIR"

    cd "$APPIMG_DIR"

    if [ ! -f "$APPIMG_DIR/nvim.appimage" ]; then
		wget -O nvim.appimage https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
	fi
    if [ ! -f "$APPIMG_DIR/nvim.appimage" ]; then
        echo "Error downloading nvim.appimage"
        exit 1
    fi
    chmod u+x "$APPIMG_DIR/nvim.appimage"
}

install_keepass() {
	if [ ! -f "$APPIMG_DIR/KeePassXC.AppImage" ]; then
		wget -O KeePassXC.AppImage https://github.com/keepassxreboot/keepassxc/releases/download/2.7.10/KeePassXC-2.7.10-x86_64.AppImage
	fi
    if [ ! -f "$APPIMG_DIR/KeePassXC.AppImage" ]; then
        echo "Error downloading KeePassXC.AppImage"
        exit 1
    fi
    chmod u+x "$APPIMG_DIR/KeePassXC.AppImage"

}

install_AppImg() {
	install_nvim
	install_keepass
}

install_app() {
	if [ ! -d "$HOME/.config/BraveSoftware" ]; then
		curl -fsS https://dl.brave.com/install.sh | sh
	fi
}

check_status() {
  echo -e "\n\n\n\n\n=== Vérification de l'installation ==="

  echo "Vérification des packages :"
  for package in $packages; do
    if dpkg -s "$package" >/dev/null 2>&1; then
      echo "package $package installed ✅"
    else
      echo "package $package not installed ❌"
    fi
  done

  echo -e "\nVérification des liens symboliques :"
  for mod in $modules; do
    case $mod in
      zsh)
        for file in .zshrc .p10k.zsh .zsh_aliases .zsh_func; do
          if [ -L "$HOME/$file" ] && [ -e "$HOME/$file" ]; then
            echo "link $file ✅"
          else
            echo "link $file ❌"
          fi
        done
        ;;
      nvim)
        if [ -L "$HOME/.config/nvim" ]; then
          echo "link nvim config ✅"
        else
          echo "link nvim config ❌"
        fi
        ;;
      font)
        if [ -d "$HOME/.fonts" ] && [ -L "$HOME/.fonts" ]; then
          echo "link font directory ✅"
        else
          echo "link font directory ❌"
        fi
        ;;
      terminator)
        if [ -L "$HOME/.config/terminator" ]; then
          echo "link terminator installed ✅"
        else
          echo "link terminator not installed ❌"
        fi
        ;;
    esac
  done

  echo -e "\nVérification des téléchargements AppImage :"
  for appimg in nvim.appimage KeePassXC.AppImage; do
    if [ -f "$APPIMG_DIR/$appimg" ]; then
      echo "$appimg downloaded ✅"
    else
      echo "$appimg not downloaded ❌"
    fi
  done

  echo -e "\nVérification de Brave :"
  if [ -d "$HOME/.config/BraveSoftware" ]; then
    echo "Brave downladed ✅"
  else
    echo "Brave not downloaded ❌"
  fi
}

if [ "$1" == "appimg" ]; then
    install_AppImg
    exit 0
elif [ command -v apt >/dev/null 2>&1 ]; then
	if [ "$1" == "cli" ]; then
		install_packages
		create_link
		install_oh_my_zsh
		install_powerlevel10k
		install_autoSuggestion
		set_zsh_default
		install_nvim
	elif [-z "$1"]; then
		install_packages
		create_link
		install_oh_my_zsh
		install_powerlevel10k
		install_autoSuggestion
		set_zsh_default
		install_AppImg
		install_app
		check_status
	else
		echo "problem"
		exit 1
	fi
else
    echo "OS or packages installer not supported"
    exit 1
fi
