#!/usr/bin/env bash
set -e -u

# Setups a new debian environment with the desired customizations.
#
# This script can be ran as is over an existing Debian installation and should cause no issues.
#
# This should be ran as a root user.

#########################
# GLOBAL CUSTOMIZATIONS #
#########################

# - Install fonts & sets them up globally
apt-get install -y \
    fonts-mononoki
cat >/etc/fonts/local.conf <<EOF
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>
  <description>Replace Latin monospace default font</description>
   <alias>
      <family>monospace</family>
      <prefer>
         <family>mononoki</family>
      </prefer>
   </alias>
</fontconfig>
EOF

# - Installs additional fonts
apt-get install -y \
    fonts-inter \
    fonts-font-awesome

# - Post: reload fonts cache
fc-cache -r


#######################
# DISPLAY ENVIRONMENT #
#######################
apt-get update

# - Installs softwares
apt-get install -y \
    grim \  # Screenshotter
    rofi \  # App launcher
    slurp \  # Select region for screenshotter
    sway \
    swaylock \  # Lockscreen
    waybar \
    wl-clipboard \  # CLI clipboard tools
    xdg-desktop-portal \
    xdg-desktop-portal-wlr \  # Necessary for screen sharing
    xorg-xserver \  # Not everything is on Wayland
    xwayland  # Wayland to X11 interop


##################
# USER SOFTWARES #
##################

# - Prepares 1password
curl -sS https://downloads.1password.com/linux/keys/1password.asc | 
    gpg --dearmor |
    dd of=/usr/share/keyrings/1password-archive-keyring.gpg
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | 
    tee /etc/apt/sources.list.d/1password.list
mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | 
    tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sS https://downloads.1password.com/linux/keys/1password.asc | 
    gpg --dearmor |
    dd of=/usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

# - Prepares vs-codium
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
    | tee /etc/apt/sources.list.d/vscodium.list

# - Ensures debian experimental repo is on
EXPERIMENTAL_REPO_LINE="deb https://deb.debian.org/debian experimental main"
if ! grep -q "${EXPERIMENTAL_REPO_LINE}" /etc/apt/sources.list; then
    echo "${EXPERIMENTAL_REPO_LINE}" >> /etc/apt/sources.list
fi

# - Installs softwares
apt-get update
apt-get install -y \
    1password \
    codium \
    flatpak \
    firefox-esr \
    git \
    mc \  # Midnight Commander (CLI-based file explorer)
    pavucontrol
apt-get -t experimental install -y \
    alacritty

# - Add flathub remote
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# - Install flatpaks
flatpak install --or-update --noninteractive flathub \
    com.discordapp.Discord \
    com.moonlight_stream.Moonlight \
    md.obsidian.Obsidian