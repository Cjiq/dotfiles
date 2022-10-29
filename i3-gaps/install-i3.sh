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
sudo cp scripts/after-login /usr/local/bin/
sudo cp scripts/fix-monitors /usr/local/bin/
sudo cp scripts/town /usr/local/bin/
sudo cp scripts/md-to-pdf /usr/local/bin/
sudo cp scripts/launch_polybar /usr/local/bin/

disp "Installing xcwd.."
source scripts/install_xcwd

disp "Fixing backlighting.."
disp "Pick your system (1-3):"
echo " 1) VirtualBox"
echo " 2) Lenovo"
echo " 3) Macbook"
echo " 4) Dell Vostro"
echo " 5) Desktop"
echo -n "> "
read SYS
case $SYS in
	1);;
	2)	sudo cp scripts/backlight_mod_lenovo /usr/local/bin/backlight_mod 
		sudo cp ../.config/70-synaptics.conf.lenovo /etc/X11/xorg.conf.d/70-synaptics.conf
		;;
	3)	sudo cp scripts/backlight_mod_mac /usr/local/bin/backlight_mod 
        sudo pacman -Sy xf86-video-intel
        sudo pacman -Rns xf86-video-vesa
        ;; 
	4)	sudo cp scripts/backlight_mod_dellv /usr/local/bin/backlight_mod ;; 
	5)  SKIP_BACKLGIHT=1;;
esac

if [ ! -n "$SKIP_BACKLIGHT" ]; then
  sudo cp sys/backlight.rules /etc/udev/rules.d/backlight.rules
fi

disp "Syncing pacman.."
sudo pacman -Sy
disp "Installing pacman dependencies.."
cat pac.dep | paste -sd " " | xargs sudo pacman -S --noconfirm --needed
if ! type yay > /dev/null; then
    disp "Installing yay..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi 
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
if [ "$SYS" -eq "3" ]; then
	sudo localectl --no-convert set-x11-keymap se macbook79
else
	sudo localectl --no-convert set-x11-keymap se pc104
fi

disp "Pick your i3 modifier key:"
echo " 1) left alt"
echo " 2) left CMD"
echo -n "> "
read MOD
case $MOD in
	1)	i3_mod=Mod1;;
	2)	i3_mod=Mod4;;
	*)	i3_mod=Mod1;;
esac
printf "set $" > ~/.dotfiles/.config/i3/config.mod
printf "mod $i3_mod" >> ~/.dotfiles/.config/i3/config.mod

# Generate i3-config-file
disp "Create config generator script"
rm -rf gen_i3_config
order="design mod vars apps"
if $IS_MANJARO; then
	order="$order manjaro"
else
	disp "Adding config section for polybar.."
	yay -S --noconfirm --needed polybar
	order="$order polybar"
	sudo ln -sf ~/.dotfiles/.config/i3/config.polybar ~/.i3-config-polybar
	ln -sf ~/.dotfiles/.config/polybar ~/.config/polybar
fi
order="$order keys end"
echo "order='$order'" > gen/vars
cat gen/head gen/vars gen/main gen/end > gen_i3_config
chmod +x gen_i3_config
disp "Run the script.."
. gen_i3_config

# Rofi
ln -sf ~/.dotfiles/.config/rofi/confg ~/.config/rofi/config

disp "Making alias to run config gen.."
sudo ln -sf ~/.dotfiles/i3-gaps/gen_i3_config /usr/local/bin/i3-config-gen
sudo ln -sf ~/.dotfiles/.config/i3/config ~/.i3-config
disp "Use ${Cya}i3-config-gen${Gre} to re-generate the config file.."
disp "Use ${Cya}i3-reload${Gre} to reload the config file.."
disp "Use ${Cya}i3-restart${Gre} to restart the i3 enviroment.."
disp "i3 gaps installation is now complete"
