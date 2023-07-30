#!/bin/sh

function commandExec() {
  sudo $1
};

# update and upgrade 
echo "Updating your system..."
sudo apt update && sudo apt upgrade -y
sleep 1
echo "Starting app installation..."

APPLIST=( 'unrar', 'git', 'snap', 'libreoffice', 'curl', 'hardinfo')

for app in "${APPLIST[@]}"
do
  echo "installing $app"
  commandExec "apt install $app -y"
done

sudo apt update

echo "downloading and installing packages"

# chrome, vscode

# snap telegram


# powerconfig for wifi


