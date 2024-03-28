#!/usr/bin/env bash
set -e -u

# Packs dotfile in the destination git repository in order to replicate them on another
# installation.

# Files to copy
COPY_DIRS=(
    ".config/scripts"
    ".config/alacritty"
    ".config/mc"
    ".config/sway"
    ".config/swaylock"
    ".config/rofi"
    ".config/waybar"
    ".config/xdg-desktop-portal"
    ".local/share/mc/skins"
    ".local/share/rofi"
    ".local/bin"
)
COPY_FILES=(
    ".profile"
)
COPY_TO_DIR=~/.dotfiles-keep

# Cleanup destination dir
mkdir -p ${COPY_TO_DIR}

# Copy all files from COPY_DIRS to COPY_TO_DIR
for d in ${COPY_DIRS[@]}; do
    cp -t ${COPY_TO_DIR} --parents -r ${d};
done

for f in ${COPY_FILES[@]}; do
    cp -t ${COPY_TO_DIR} --parents ${f};
done