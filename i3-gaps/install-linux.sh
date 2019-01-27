#!/bin/bash

# Do prep
source ../scripts/prepare.sh

disp "Moving scripts.."
# cp scripts/spotify-current /usr/local/bin/
# cp scripts/sp /usr/local/bin/
# cp scripts/octave_math /usr/local/bin/
# cp scripts/set-resolution /usr/local/bin/


disp "Syncing pacman.."
# sudo pacman -Sy
disp "Installing pacman dependencies.."
# cat pac.dep | paste -sd " " | xargs sudo pacman -S --noconfirm
disp "Installing yay..."
# git clone https://aur.archlinux.org/yay.git
# cd yay
# makepkg -si
# cd ..
# rm -rf yay
disp "Installing yay dependencies.."
# cat yay.dep | paste -sd " " | xargs yay -S --noconfirm

IS_MANJARO=false
while true; do
	echo -e -n "${Gre}Are you running Manjaro? (Y/n): ${RCol}" 
	read yn
	case $yn in
		[Yy]* ) 
			IS_MANJARO=true
		break;;
		[Nn]* ) break;;
		* ) echo "Please answer yes or no.";;
  esac
done

#Remove old i3 gen script
rm -rf gen_i3_config
cat gen/main > gen_i3_config
if $IS_MANJARO; then
	disp "Adding config section for manjaro.."
	cat gen/manjaro >> gen_i3_config
else
	disp "Adding config section for polybar.."
	yay -S --noconfirm polybar
	cat gen/polybar >> gen_i3_config
fi
cat gen/end >> gen_i3_config
chmod +x gen_i3_config
disp "Done! Have a nice day :)"
