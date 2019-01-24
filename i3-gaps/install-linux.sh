#!/bin/bash

cp ../scripts/spotify-current ~/usr/local/bin/
cp ../scripts/sp ~/usr/local/bin/
cp ../scripts/octave_math ~/usr/local/bin/
cp ../scripts/set-resolution ~/usr/local/bin/

source ../scripts/prepare.sh

echo "Sync pacman.."
sudo pacman -Sy
echo "Install pacman dependencies.."
cat pac.dep | paste -sd " " | xargs sudo pacman -S --no-confirm
echo "Install yay.."
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay
echo "Install yay dependencies.."
cat yay.dep | paste -sd " " | xargs yay -S --no-confirm

