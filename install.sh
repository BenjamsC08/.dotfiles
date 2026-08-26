#!/usr/bin/env bash
# Portable bootstrap for Debian 12/13: zsh, nvim, terminator.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APPIMG_DIR="$DOTFILES_DIR/AppImg"
LOCAL_BIN="$HOME/.local/bin"
MODULES=(font nvim zsh terminator)

info() { printf '==> %s\n' "$*"; }
warn() { printf 'warn: %s\n' "$*" >&2; }
die()  { printf 'error: %s\n' "$*" >&2; exit 1; }

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "missing command: $1"
}

os_check() {
  if [[ ! -r /etc/os-release ]]; then
    die "cannot read /etc/os-release"
  fi
  # shellcheck disable=SC1091
  . /etc/os-release
  if [[ "${ID:-}" != "debian" ]]; then
    die "this installer targets Debian 12/13 (found ID=${ID:-unknown})"
  fi
  case "${VERSION_ID:-}" in
    12|13) info "Debian ${VERSION_ID} detected" ;;
    *)
      warn "Debian ${VERSION_ID:-?} is untested (supported: 12, 13)"
      ;;
  esac
  command -v apt-get >/dev/null 2>&1 || die "apt-get not found"
}

fuse_package() {
  # Debian 13 (t64 transition) vs Debian 12.
  case "${VERSION_ID:-}" in
    13) printf '%s\n' "libfuse2t64" ;;
    *)  printf '%s\n' "libfuse2" ;;
  esac
}

nvim_asset() {
  case "$(uname -m)" in
    x86_64)  printf '%s\n' "nvim-linux-x86_64.appimage" ;;
    aarch64) printf '%s\n' "nvim-linux-arm64.appimage" ;;
    *) die "unsupported architecture: $(uname -m)" ;;
  esac
}

pkg_installed() {
  dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "install ok installed"
}

install_packages() {
  local fuse pkg
  fuse="$(fuse_package)"
  local packages=(
    stow wget curl ca-certificates git
    zsh terminator
    fontconfig unzip
    gcc clang build-essential make
    gdb valgrind bear
    ripgrep xclip xsel
    bat
    clangd
    "$fuse"
  )

  local missing=()
  for pkg in "${packages[@]}"; do
    if pkg_installed "$pkg"; then
      info "package $pkg already installed"
    else
      missing+=("$pkg")
    fi
  done

  if ((${#missing[@]} == 0)); then
    info "all apt packages already installed"
    return 0
  fi

  command -v sudo >/dev/null 2>&1 || die "sudo is required to install packages"
  info "apt-get update"
  sudo apt-get update
  info "installing: ${missing[*]}"
  if ! sudo apt-get install -y "${missing[@]}"; then
    if [[ "$fuse" == "libfuse2t64" ]]; then
      warn "libfuse2t64 failed, trying libfuse2"
      local retry=()
      local p
      for p in "${missing[@]}"; do
        if [[ "$p" == "libfuse2t64" ]]; then
          retry+=("libfuse2")
        else
          retry+=("$p")
        fi
      done
      sudo apt-get install -y "${retry[@]}"
    else
      die "apt-get install failed"
    fi
  fi
}

install_oh_my_zsh() {
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    info "oh-my-zsh already installed"
    return 0
  fi
  info "installing oh-my-zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    "" --unattended
}

install_p10k() {
  local dest="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
  if [[ -d "$dest" ]]; then
    info "powerlevel10k already installed"
    return 0
  fi
  info "installing powerlevel10k"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$dest"
}

install_autosuggestions() {
  local dest="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  if [[ -d "$dest" ]]; then
    info "zsh-autosuggestions already installed"
    return 0
  fi
  info "installing zsh-autosuggestions"
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$dest"
}

backup_if_real() {
  local target="$1"
  if [[ -e "$target" && ! -L "$target" ]]; then
    local bak="${target}.bak.$(date +%Y%m%d%H%M%S)"
    info "backup $target -> $bak"
    mv "$target" "$bak"
  fi
}

create_links() {
  need_cmd stow
  mkdir -p "$HOME/.config"

  backup_if_real "$HOME/.zshrc"
  backup_if_real "$HOME/.p10k.zsh"
  backup_if_real "$HOME/.zsh_aliases"
  backup_if_real "$HOME/.zsh_func"
  backup_if_real "$HOME/.config/nvim"
  backup_if_real "$HOME/.config/terminator"

  info "stow ${MODULES[*]}"
  (
    cd "$DOTFILES_DIR"
    local mod
    for mod in "${MODULES[@]}"; do
      stow -R "$mod"
    done
  )
}

install_nvim() {
  local asset dest
  asset="$(nvim_asset)"
  dest="$APPIMG_DIR/nvim.appimage"

  mkdir -p "$APPIMG_DIR" "$LOCAL_BIN"

  if [[ ! -f "$dest" ]]; then
    info "downloading Neovim AppImage ($asset)"
    curl -fL --retry 3 --retry-delay 2 \
      -o "$dest" \
      "https://github.com/neovim/neovim/releases/latest/download/${asset}"
  else
    info "nvim.appimage already present"
  fi

  [[ -s "$dest" ]] || die "nvim.appimage download failed"
  chmod u+x "$dest"
  ln -sfn "$dest" "$LOCAL_BIN/nvim"
  info "nvim -> $LOCAL_BIN/nvim"
}

refresh_fonts() {
  if command -v fc-cache >/dev/null 2>&1; then
    info "refreshing font cache"
    fc-cache -f "$HOME/.fonts" >/dev/null 2>&1 || fc-cache -f
  else
    warn "fc-cache not found, skip font cache"
  fi
}

set_zsh_default() {
  local zsh_path
  zsh_path="$(command -v zsh)" || die "zsh not installed"
  if [[ "${SHELL:-}" == "$zsh_path" ]]; then
    info "zsh is already the default shell"
    return 0
  fi
  info "setting zsh as default shell"
  if ! chsh -s "$zsh_path"; then
    warn "chsh failed; run: chsh -s $zsh_path"
  fi
}

link_ok() {
  [[ -L "$1" && -e "$1" ]]
}

check_status() {
  printf '\n=== status ===\n'

  local pkg fuse
  fuse="$(fuse_package)"
  for pkg in stow zsh terminator git curl wget ripgrep clangd "$fuse"; do
    if pkg_installed "$pkg"; then
      printf 'package %s ok\n' "$pkg"
    else
      printf 'package %s MISSING\n' "$pkg"
    fi
  done

  local file
  for file in .zshrc .p10k.zsh .zsh_aliases .zsh_func; do
    if link_ok "$HOME/$file"; then
      printf 'link ~/%s ok\n' "$file"
    else
      printf 'link ~/%s MISSING\n' "$file"
    fi
  done

  if link_ok "$HOME/.config/nvim" || [[ -L "$HOME/.config/nvim/init.lua" ]]; then
    printf 'link nvim config ok\n'
  else
    printf 'link nvim config MISSING\n'
  fi

  if link_ok "$HOME/.config/terminator" || [[ -L "$HOME/.config/terminator/config" ]]; then
    printf 'link terminator ok\n'
  else
    printf 'link terminator MISSING\n'
  fi

  if [[ -d "$HOME/.fonts" ]]; then
    printf 'fonts dir ok\n'
  else
    printf 'fonts dir MISSING\n'
  fi

  if [[ -x "$LOCAL_BIN/nvim" ]]; then
    printf 'nvim wrapper ok (%s)\n' "$LOCAL_BIN/nvim"
  else
    printf 'nvim wrapper MISSING\n'
  fi

  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    printf 'oh-my-zsh ok\n'
  else
    printf 'oh-my-zsh MISSING\n'
  fi

  if [[ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
    printf 'powerlevel10k ok\n'
  else
    printf 'powerlevel10k MISSING\n'
  fi

  if [[ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
    printf 'zsh-autosuggestions ok\n'
  else
    printf 'zsh-autosuggestions MISSING\n'
  fi
}

usage() {
  cat <<EOF
usage: $(basename "$0") [check]

  (no args)  install packages, stow configs, nvim, zsh
  check      print status only
EOF
}

main() {
  case "${1:-}" in
    -h|--help)
      usage
      exit 0
      ;;
    check)
      os_check
      check_status
      exit 0
      ;;
    "")
      ;;
    *)
      usage >&2
      exit 1
      ;;
  esac

  os_check
  install_packages
  install_oh_my_zsh
  install_p10k
  install_autosuggestions
  create_links
  install_nvim
  refresh_fonts
  set_zsh_default
  check_status
  info "done. open a new terminal (or exec zsh)."
  info "machine-specific PATH/aliases go in ~/.zshrc.local"
}

main "$@"
