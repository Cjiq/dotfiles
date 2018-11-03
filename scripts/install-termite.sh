#!/bin/bash

# Load some setup variables
source "${BASH_SOURCE%/*}/prepare.sh"

# 1. Download termite
# 2. Install
# 3. Move config

while true; do
  echo -e "${Gre}This script will download and reinstall termite. Do you whish to continue? (Y/n)${RCol}"
  read yn
  case $yn in
    [Yy]* ) break;;
    [Nn]* ) exit;;
    * ) echo "Please answer yes or no.";;
  esac
done

sudo pacman -Sy --noconfirm termite

if [ ! -d "~/.config/termite" ]; then
	 mkdir -p ~/.config/termite
fi

cp -f "${BASH_SOURCE%/*}/../termite-config" ~/.config/termite/config
# cp -f ../termite-config ~/.config/termite/config

echo -e "${Gre} All done! Have a nice day :)${RCol}"
