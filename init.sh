#!/bin/bash

execute() {
  sudo $1
  if [ $? -eq 0 ]; then
  echo "[+] Succeded!"
  else
  echo "[!] Error! Process $1 failed."
  fi 
};

logs() {  
  echo "[process] $1"
}

# update and upgrade 
logs "Updating your system..."
sudo apt update && sudo apt upgrade -y
sleep 1
echo "Starting app installation..."

APPLIST=("unrar" "git" "snap" "libreoffice" "curl" "hardinfo")

for app in "${APPLIST[@]}"
do
  echo "installing $app"
  commandExec "apt install $app -y"
done

sudo apt update

echo "downloading and installing packages"

# chrome, vscode

sudo apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

sudo apt install apt-transport-https
sudo apt update
sudo apt install code # or code-insiders


# snap telegram
sudo snap install telegram-desktop

# powerconfig for wifi

# sudo nano /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
sudo systemctl restart NetworkManager

sleep 10

