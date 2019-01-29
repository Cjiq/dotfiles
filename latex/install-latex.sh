#!/bin/bash

source ../scripts/prepare.sh
disp "Installing LaTex..."
disp "This can take a while.. so perfect time for a coffee :)"
sudo pacman -S texlive-most --noconfirm

disp "Creating LaTex template folders.."
mkdir -p ~/.latex/templates
sudo cp texplate /usr/local/bin
disp "Use ${Red}texplate list${Gre} to show available templates"
disp "And use ${Red}texplate copy <template> <destination>${Gre} to copy named template to given folder"
disp "Done! Have a nice day."
