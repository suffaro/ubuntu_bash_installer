#!/bin/bash

REPOSITORIES=("ppa:qbittorrent-team/qbittorrent-stable")
APPLICATIONS=("hardinfo" "snap" "perl" "gcc" "qbittorrent" "wget" "libreoffice" "unrar" "vim" "net-tools" "dconf-editor")
SNAP_APPLICATIONS=("telegram-desktop" "node --classic --channel=latest/edge" "code --classic" "discord")
LINKS=("https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb")


process_track() {
  while ps -p $1 > /dev/null
  do
    progress_bar
  done
  echo -e "\b+"
}


echo "Hi! This script is going to install ubuntu with all needed soft on your laptop.\n Please press enter to launch installation..."

read -n 1

clear

source test.sh


interface "Phase 1: Starting installation..." 1

{
  sudo apt-get update && sudo apt-get upgrade -y
} &> /dev/null

# p1=$!
# process_track $p1

for elem in ${REPOSITORIES[@]}
do
  interface "Adding $elem to your repositories..." 0
  {
  sudo add-apt-repository $elem -y & 
  } 1> /dev/null
  p1=$!
  process_track $p1
done

interface "Updating repositories..." 0

{
  sudo apt-get update & 
} 1> /dev/null

p1=$!
process_track $p1

interface "Phase 2: App installation..." 1
for elem in ${APPLICATIONS[@]}
do
  interface "Installing $elem in your system..." 0
  {
  sudo apt-get install $elem -y & 
  } 1> /dev/null
  p1=$!
  process_track $p1  
done

interface "Phase 3: Snap applications..." 1
for ((i = 0; i < ${#SNAP_APPLICATIONS[@]}; i++))
do
  interface "Installing ${SNAP_APPLICATIONS[$i]} in your system..." 0
  {
  sudo snap install ${SNAP_APPLICATIONS[$i]} & 
  } 1> /dev/null
  p1=$p1
  process_track $p1
done


DOWNLOAD_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
# File name after downloading
DOWNLOAD_FILE="google-chrome-stable_current_amd64.deb"

# Download the file using wget
interface "Downloading $DOWNLOAD_FILE..." 1
wget "$DOWNLOAD_URL" &> /dev/null

# Check if the download was successful
if [ $? -eq 0 ]; then
    interface "Download successful." 1

    # Install the downloaded package using dpkg
    interface "Installing $DOWNLOAD_FILE..." 1
    sudo dpkg -i "$DOWNLOAD_FILE" &> /dev/null

    # Check if the installation was successful
    if [ $? -eq 0 ]; then
        interface "Installation successful." 1
    else
        interface "Installation failed." 1
    fi
else
    interface "Download failed." 1
fi

# Clean up: remove the downloaded file
interface "Cleaning up..." 1
rm -f "$DOWNLOAD_FILE"


interface "Phase 4: Configuration of system..." 0

#time change for dualboot
timedatectl set-local-rtc 1

#dock and icons


#terminal (HARDEST PART)




#wifi powerchange
sudo sed -i "s/3/2/" /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf

sudo systemctl restart NetworkManager


echo "Installation complete!"