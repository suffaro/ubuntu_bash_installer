#!/bin/bash

REPOSITORIES=("ppa:qbittorrent-team/qbittorrent-stable")
APPLICATIONS=("hardinfo" "snap" "perl" "gcc" "qbittorrent" "wget" "libreoffice" "unrar" "vim" "net-tools")
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

clear

source test.sh


interface "Phase 1: Starting installation..." 1

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


interface "Chrome downloading..." 1

{ 
  sudo wget ${LINKS[0]} -O ./gc.deb & 
} 1> /dev/null

p1=$p1
process_track $p1

interface "Chrome installation..." 1
{
  sudo dpkg -i ./gc.deb &
} 1> /dev/null
p1=$p1
process_track $p1


