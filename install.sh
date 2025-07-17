#!/bin/bash

set -euo pipefail

# ───────────────────────────────────────────────────────────────
# Arch Dotfiles Install Script
# By: Rajbir (2025)
# Description: Symlinks config files, fixes bad links,
#              installs essentials (fonts, terminal, notifications, waybar)
# ───────────────────────────────────────────────────────────────

echo "🚀 Starting dotfiles bootstrap..."

# Set up paths
DOTFILES="$HOME/dotfiles"
CONFIGS=(kitty hypr waybar mako)
LOCAL_BIN="$HOME/.local/bin"

# ───────────────────────────────────────────────────────────────
# Step 1: Fix any broken/nested symlinks
# ───────────────────────────────────────────────────────────────

echo "🧹 Cleaning nested symlinks in dotfiles..."
find "$DOTFILES/.config" -type l | while read -r symlink; do
  target=$(readlink "$symlink")
  if [[ "$target" == *dotfiles* ]]; then
    echo "⚠️  Removing nested symlink: $symlink"
    rm "$symlink"
  fi
done

# ───────────────────────────────────────────────────────────────
# Step 2: Symlink configs to ~/.config
# ───────────────────────────────────────────────────────────────

echo "🔗 Creating config symlinks..."
for tool in "${CONFIGS[@]}"; do
  config_path="$HOME/.config/$tool"
  repo_path="$DOTFILES/.config/$tool"

  if [ -e "$config_path" ] || [ -L "$config_path" ]; then
    echo "🧹 Removing existing $config_path"
    rm -rf "$config_path"
  fi

  ln -s "$repo_path" "$config_path"
  echo "✅ Linked $tool config"
done

# ───────────────────────────────────────────────────────────────
# Step 2.5: Symlink .zshrc from dotfiles/.config/zsh
# ───────────────────────────────────────────────────────────────

ZSHRC_LINK="$HOME/.zshrc"
ZSHRC_SOURCE="$DOTFILES/.config/zsh/.zshrc"

if [ -e "$ZSHRC_LINK" ] || [ -L "$ZSHRC_LINK" ]; then
  echo "🧹 Removing existing ~/.zshrc"
  rm -f "$ZSHRC_LINK"
fi

ln -s "$ZSHRC_SOURCE" "$ZSHRC_LINK"
echo "✅ Symlinked .zshrc → $ZSHRC_SOURCE"

# ───────────────────────────────────────────────────────────────
# Step 3: Ensure .local/bin exists and is symlinked
# ───────────────────────────────────────────────────────────────

mkdir -p "$LOCAL_BIN"

# ───────────────────────────────────────────────────────────────
# Step 4: Install core packages
# ───────────────────────────────────────────────────────────────

echo "📦 Installing required packages..."
sudo pacman -S --noconfirm \
  kitty \
  zsh \
  ttc-iosevka \
  ttf-iosevka-nerd \
  waybar \
  mako \
  swaybg \
  git \
  base-devel \
  jq

# ───────────────────────────────────────────────────────────────
# Step 5: Set zsh as default shell
# ───────────────────────────────────────────────────────────────

if [ "$SHELL" != "/bin/zsh" ]; then
  echo "🌀 Setting zsh as default shell..."
  chsh -s /bin/zsh
fi

# ───────────────────────────────────────────────────────────────
# Step 6: Create wallpaper folder (optional)
# ───────────────────────────────────────────────────────────────

mkdir -p "$HOME/Pictures/wallpapers"

# ───────────────────────────────────────────────────────────────
# Step 7: GitHub SSH Config Reminder (optional)
# ───────────────────────────────────────────────────────────────

echo "🔐 (Optional) Set up SSH for GitHub with ssh-keygen if needed."

# ───────────────────────────────────────────────────────────────
# Done
# ───────────────────────────────────────────────────────────────

echo "🎉 All done. Log out and back in, or reboot to apply everything."
echo "👉 You may also want to run: source ~/.zshrc"
