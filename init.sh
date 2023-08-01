#!/bin/bash

REPOSITORIES=("ppa:qbittorrent-team/qbittorrent-stable")
APPLICATIONS=("hardinfo" "snap" "perl" "gcc" "qbittorrent" "wget" "libreoffice" "unrar" "vim" "net-tools")
SNAP_APPLICATIONS=("telegram-desktop" "nodejs???" "code --classic" "discord")
LINKS=("https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb")


process_track() {
  while ps -p $1 > /dev/null
  do
    progress_bar
  done
  echo "Success!!"
}



echo "Hi! This script is going to install ubuntu with all needed soft on your laptop.\n Please press enter to launch installation..."

clear

source test.sh


interface "Phase 1: Starting installation..." 1

for elem in ${REPOSITORIES[@]}
do
  interface "Adding $elem to your repositories..."
  sleep 5
  sudo add-apt-repository $elem -y & 1> /dev/null
  p1=$!
  process_track $p1
done

interface "Updating repositories..." 1

sudo apt update & 1> /dev/null

p1=$!
process_track $p1

interface "Phase 2: App installation..." 1
for elem in ${APPLICATIONS[@]}
do
  interface "Installing $elem in your system..."
  sudo apt install $elem -y & 1> /dev/null
  p1=$!
  process_track $p1  
done

interface "Phase 3: Snap applications..." 1
for elem in ${SNAP_APPLICATIONS[@]}
do
  interface "Installing $elem in your system..."
  sudo snap install $elem & 1> /dev/null
  p1=$p1
  process_track $p1
done


interface "Chrome installation..."

wget $LINKS[0]
wait
sudo dpkg -i google-chrome-stable_current_amd64.deb
p1=$p1
process_track $p1


