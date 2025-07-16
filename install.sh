#!/bin/bash

echo "🔗 Symlinking configs..."

ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.zprofile ~/.zprofile
ln -sf ~/dotfiles/.config/kitty ~/.config/kitty
ln -sf ~/dotfiles/.config/hypr ~/.config/hypr

mkdir -p ~/.local/bin
ln -sf ~/dotfiles/bin/bemenu-launch ~/.local/bin/bemenu-launch

echo "✅ Dotfiles linked."

