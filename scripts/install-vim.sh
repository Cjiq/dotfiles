#!/bin/bash

# Load some setup variables
source "${BASH_SOURCE%/*}/prepare.sh"

if [[ $DIST == "centos" ]]; then
	echo "centos!!"
elif [[ $DIST == "arch" ]]; then
	echo "arch!!"
fi

# 1. install vim
#    1. check system
#    2. download vim and install
# 2. install vundle
# 3. fetch dotvim

while true; do
	echo -e "${Gre}This script will delete your old .vim and do a clean install. Do you wish to continue? (Y/n)${RCol}"
	read yn
	case $yn in
		[Yy]* ) break;;
	[Nn]* ) exit;;
* ) echo "Please answer yes or no.";;
  esac
done

# install VIM
echo -e "Downloading vim.."
if [[ "$OSTYPE" == "darwin"* ]]; then
	brew install --HEAD vim > /dev/null
elif [[ $DIST == "centos" ]]; then
	sudo yum install -y vim > /dev/null
elif [[ $DIST == "arch" ]]; then
	sudo pacman -Sy --noconfirm vim > /dev/null
fi

while true; do
	echo -e "${Gre}Do you wish to install neovim aswell? (Y/n)${RCol}"
	read yn
	case $yn in
		[Yy]* ) 
			if [[ "$OSTYPE" == "darwin"* ]]; then
				brew tap neovim/neovim > /dev/null
				brew install --HEAD neovim > /dev/null
			elif [[ $DIST == "centos" ]]; then
				sudo yum install -y neovim > /dev/null
			elif [[ $DIST == "arch" ]]; then
				sudo pacman -Sy --noconfirm neovim > /dev/null
			fi
			ln -sf ~/.vim ~/.config/nvim
			echo -e "${Gre}NeoVim installation complete! :D${RCol}"
			break;;
		[Nn]* ) break;;
	* ) echo "Please answer yes or no.";;
esac
done

rm -rf ~/.vim
mkdir -p ~/.vim/bundle/Vundle.vim

# Clone vundle and install to default install location
echo -e "Downloading vundle.."
git clone --quiet https://github.com/VundleVim/Vundle.vim.git ~/temp-vundle > /dev/null
mv ~/temp-vundle/* ~/temp-vundle/.[^.]* ~/.vim/bundle/Vundle.vim
rm -rf ~/temp-vundle

# Install dotvim
echo -e "Downloading dotvim.."
git clone --quiet https://github.com/Cjiq/dotvim.git ~/temp-dotfiles > /dev/null
mv ~/temp-dotfiles/* ~/temp-dotfiles/.[^.]* ~/.vim
rm -rf ~/temp-dotfiles

# Run vundle plugin install
echo -e "Installing vundle plugins. This could take some time.."
vim +PluginInstall +qa > /dev/null

# Use same vim settings for root as for user.
sudo ln -sf /home/${USER}/.vim /.vim 

# Install patched fonts
# If arch then install patched font.
if [[ $DIST == "arch" ]]  ||  [[ "$OSTYPE" == "darwin"* ]] || [[ $DIST == "centos" ]]; then
	echo -e "Downloading and patching fonts.."
	git clone --quiet https://github.com/powerline/fonts/ ~/temp-p-fonts > /dev/null
	cd ~/temp-p-fonts
	source install.sh
	rm -rf ~/temp-p-fonts
fi

echo -e "${Gre}Installation complete! :D${RCol}"
