#!/bin/bash

# Init some default colors and stuff
RCol='\e[0m'    # Text Reset

# Regular           Bold                Underline           High Intensity      BoldHigh Intens     Background          High Intensity Backgrounds
Bla='\e[0;30m';     BBla='\e[1;30m';    UBla='\e[4;30m';    IBla='\e[0;90m';    BIBla='\e[1;90m';   On_Bla='\e[40m';    On_IBla='\e[0;100m';
Red='\e[0;31m';     BRed='\e[1;31m';    URed='\e[4;31m';    IRed='\e[0;91m';    BIRed='\e[1;91m';   On_Red='\e[41m';    On_IRed='\e[0;101m';
Gre='\e[0;32m';     BGre='\e[1;32m';    UGre='\e[4;32m';    IGre='\e[0;92m';    BIGre='\e[1;92m';   On_Gre='\e[42m';    On_IGre='\e[0;102m';
Yel='\e[0;33m';     BYel='\e[1;33m';    UYel='\e[4;33m';    IYel='\e[0;93m';    BIYel='\e[1;93m';   On_Yel='\e[43m';    On_IYel='\e[0;103m';
Blu='\e[0;34m';     BBlu='\e[1;34m';    UBlu='\e[4;34m';    IBlu='\e[0;94m';    BIBlu='\e[1;94m';   On_Blu='\e[44m';    On_IBlu='\e[0;104m';
Pur='\e[0;35m';     BPur='\e[1;35m';    UPur='\e[4;35m';    IPur='\e[0;95m';    BIPur='\e[1;95m';   On_Pur='\e[45m';    On_IPur='\e[0;105m';
Cya='\e[0;36m';     BCya='\e[1;36m';    UCya='\e[4;36m';    ICya='\e[0;96m';    BICya='\e[1;96m';   On_Cya='\e[46m';    On_ICya='\e[0;106m';
Whi='\e[0;37m';     BWhi='\e[1;37m';    UWhi='\e[4;37m';    IWhi='\e[0;97m';    BIWhi='\e[1;97m';   On_Whi='\e[47m';    On_IWhi='\e[0;107m';

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

# Detect if wget is installed
if [ ! -x /usr/bin/wget ] ; then
    # some extra check if wget is not installed at the usual place                                                                           
    command -v wget >/dev/null 2>&1 || { echo >&2 "Please install wget or set it in your path. Aborting."; exit 1; }
fi

# Detect if the system is running ArchLinux, if not install pacapt
if [ ! -f "/etc/arch-release" ]; then
    # install pacapt to install vim for most versions of unix/linux systems
    wget -O /usr/local/bin/pacapt \
         https://github.com/icy/pacapt/raw/ng/pacapt

    sudo chmod 755 /usr/local/bin/pacapt

    sudo ln -sv /usr/local/bin/pacapt /usr/local/bin/pacman || true
fi


if [[ "$OSTYPE" == "darwin"* ]]; then
	pacman -S --noconfirm vim
else
	sudo pacman -Sy --noconfirm neovim
fi

while true; do
  echo -e "${Gre}Do you wish to install neovim aswell? (Y/n)${RCol}"
  read yn
  case $yn in
    [Yy]* ) 
		if [[ "$OSTYPE" == "darwin"* ]]; then
			brew tap neovim/neovim
			brew install --HEAD neovim
		else
			sudo pacman -Sy --noconfirm neovim
		fi
		ln -sf ~/.vim ~/.config/nvim
		echo -e "${Gre}NeoVim installation complete! :D${RCol}"
		break;;
    [Nn]* ) exit;;
    * ) echo "Please answer yes or no.";;
  esac
done

rm -rf ~/.vim
mkdir -p ~/.vim/bundle/Vundle.vim

# Clone vundle and install to default install location
git clone https://github.com/VundleVim/Vundle.vim.git ~/temp-vundle
mv ~/temp-vundle/* ~/temp-vundle/.[^.]* ~/.vim/bundle/Vundle.vim
rm -rf ~/temp-vundle

# Install dotvim
git clone https://github.com/Cjiq/dotvim.git ~/temp-dotfiles
mv ~/temp-dotfiles/* ~/temp-dotfiles/.[^.]* ~/.vim
rm -rf ~/temp-dotfiles

# Run vundle plugin install
vim +PluginInstall +qa

# Use same vim settings for root as for user.
sudo ln -sf /home/${USER}/.vim /.vim 

# Install patched fonts
# If arch then install patched font.
if [ -f "/etc/arch-release"]  ||  [[ "$OSTYPE" == "darwin"* ]]; then
		git clone https://github.com/powerline/fonts/ ~/temp-p-fonts
		cd ~/temp-p-fonts
		source install.sh
		rm -rf ~/temp-p-fonts
fi

echo -e "${Gre}Installation complete! :D${RCol}"
