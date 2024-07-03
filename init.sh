#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -o pipefail  # Ensure pipeline errors are caught

# Function for logging
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a install.log
}

# Function for error handling
error_handler() {
    log "Error occurred in line $1"
    exit 1
}

trap 'error_handler $LINENO' ERR

REPOSITORIES=(
    "ppa:qbittorrent-team/qbittorrent-stable"
)

APPLICATIONS=(
    "hardinfo" "snap" "perl" "gcc" "qbittorrent" "wget" "libreoffice" 
    "unrar" "vim" "net-tools" "dconf-editor"
)

SNAP_APPLICATIONS=(
    "telegram-desktop"
    "node --classic --channel=latest/edge"
    "code --classic"
    "discord"
)

DOWNLOAD_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
DOWNLOAD_FILE="google-chrome-stable_current_amd64.deb"

process_track() {
    local pid=$1
    while ps -p $pid > /dev/null; do
        progress_bar
    done
    echo -e "\b+"
}

progress_bar() {
    local chars=('-' '\' '|' '/')
    printf "\b${chars[i++%${#chars[@]}]}"
}

add_repositories() {
    for repo in "${REPOSITORIES[@]}"; do
        log "Adding $repo to your repositories..."
        sudo add-apt-repository "$repo" -y &>/dev/null &
        process_track $!
    done
}

install_applications() {
    for app in "${APPLICATIONS[@]}"; do
        log "Installing $app in your system..."
        sudo apt-get install "$app" -y &>/dev/null &
        process_track $!
    done
}

install_snap_applications() {
    for app in "${SNAP_APPLICATIONS[@]}"; do
        log "Installing $app via snap..."
        sudo snap install $app &>/dev/null &
        process_track $!
    done
}

configure_gnome_settings() {
    log "Configuring GNOME dock settings..."
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
    gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 24
    gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
    gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
}

install_chrome() {
    log "Downloading $DOWNLOAD_FILE..."
    if wget "$DOWNLOAD_URL" &>/dev/null; then
        log "Download successful."
        log "Installing $DOWNLOAD_FILE..."
        if sudo dpkg -i "$DOWNLOAD_FILE" &>/dev/null; then
            log "Installation successful."
        else
            log "Installation failed."
            return 1
        fi
    else
        log "Download failed."
        return 1
    fi
    log "Cleaning up..."
    rm -f "$DOWNLOAD_FILE"
}

main() {
    log "Starting installation..."

    sudo apt-get update && sudo apt-get upgrade -y

    add_repositories
    log "Updating repositories..."
    sudo apt-get update &>/dev/null &
    process_track $!

    install_applications
    install_snap_applications
    install_chrome

    log "Configuring system..."
    timedatectl set-local-rtc 1
    sudo sed -i "s/3/2/" /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
    sudo systemctl restart NetworkManager

    configure_gnome_settings  # Add this line to configure GNOME settings

    log "Installation complete!"
}

# Run the main function
main