#!/bin/bash

# Do prep
source ../scripts/prepare.sh

disp "Moving scripts.."
disp "This action requires sudo."
sudo cp scripts/spotify-current /usr/local/bin/
sudo cp scripts/sp /usr/local/bin/
sudo cp scripts/octave_math /usr/local/bin/
sudo cp scripts/set-resolution /usr/local/bin/
sudo cp scripts/i3-reload /usr/local/bin/
sudo cp scripts/i3-restart /usr/local/bin/
sudo cp scripts/blurlock /usr/local/bin/
sudo cp scripts/sus /usr/local/bin/

disp "Installing xcwd.."
source scripts/install_xcwd

disp "Fixing backlighting.."
disp "Pick your system (1-3):"
echo " 1) VirtualBox"
echo " 2) Lenovo"
echo " 3) Macbook"
echo " 4) Dell Vostro"
echo -n "> "
read SYS
case $SYS in
	1);;
	2)	sudo cp scripts/backlight_mod_lenovo /usr/local/bin/backlight_mod ;;
	3)	sudo cp scripts/backlight_mod_mac /usr/local/bin/backlight_mod ;; 
	4)	sudo cp scripts/backlight_mod_dellv /usr/local/bin/backlight_mod ;; 
esac
sudo cp sys/backlight.rules /etc/udev/rules.d/backlight.rules

disp "Syncing pacman.."
sudo pacman -Sy
disp "Installing pacman dependencies.."
cat pac.dep | paste -sd " " | xargs sudo pacman -S --noconfirm --needed
disp "Installing yay..."
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
rm -rf yay
disp "Installing yay dependencies.."
cat yay.dep | paste -sd " " | xargs yay -S --noconfirm --needed

# Enable ly as the login manager :)
sudo systemctl enable ly.service
sudo systemctl disable getty@tty2.service

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

# Set keyboard layout
sudo localectl --no-convert set-x11-keymap se pc104

#Remove old i3 gen script
disp "Create config generator script"
rm -rf gen_i3_config
cat gen/main > gen_i3_config
if $IS_MANJARO; then
	disp "Adding config section for manjaro.."
	cat gen/manjaro >> gen_i3_config
	sudo ln -sf ~/.dotfiles/.config/i3/config.manjaro ~/.i3-config-manjaro
else
	disp "Adding config section for polybar.."
	yay -S --noconfirm polybar
	cat gen/polybar >> gen_i3_config
	sudo ln -sf ~/.dotfiles/.config/i3/config.polybar ~/.i3-config-polybar
	ln -sf ~/.dotfiles/.config/polybar ~/.config/polybar
fi
cat gen/end >> gen_i3_config
chmod +x gen_i3_config
disp "Run the script.."
source gen_i3_config
disp "Making alias to run config gen.."
sudo ln -sf ~/.dotfiles/i3-gaps/gen_i3_config /usr/local/bin/i3-config-gen
sudo ln -sf ~/.dotfiles/.config/i3/config ~/.i3-config
disp "Use ${Cya}i3-config-gen${Gre} to re-generate the config file.."
disp "Use ${Cya}i3-reload${Gre} to reload the config file.."
disp "Use ${Cya}i3-restart${Gre} to restart the i3 enviroment.."
disp "i3 gaps installation is now complete"
