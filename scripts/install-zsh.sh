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

# 1. Download zsh.
# 2. Copy .zshrc
# 3. Install plugins.
# 4. Ask to set zsh as default shell.

while true; do
  echo -e "${Gre}This script will download zsh and overwirte your old .zshrc config. Do you whish to continue? (Y/n)${RCol}"
  read yn
  case $yn in
    [Yy]* ) break;;
    [Nn]* ) exit;;
    * ) echo "Please answer yes or no.";;
  esac
done

# Detect if the system is running ArchLinux, if not install pacapt
if [ ! -f "/etc/arch-release" ]; then
    # install pacapt to install vim for most versions of unix/linux systems

		# Check if it is already installed.
		hash /usr/local/bin/pacapt 2>&1 || {
				wget -O /usr/local/bin/pacapt \
						https://github.com/icy/pacapt/raw/ng/pacapt

				sudo chmod 755 /usr/local/bin/pacapt

				sudo ln -sv /usr/local/bin/pacapt /usr/local/bin/pacman || true
		}
fi

# Update "pacman"
sudo pacman -Sy
# Install zsh

#If osx dont use --noconfirm its not supported
if [[ "$OSTYPE" == "darwin"* ]]; then
		sudo pacman -R zsh
		sudo pacman -S zsh
else
		sudo pacman -R --noconfirm zsh
		sudo pacman -S --noconfirm zsh
fi
# Install oh-my-zsh
if [ ! -n "$ZSH" ]; then
    ZSH=~/.oh-my-zsh
fi

if [ -d "$ZSH" ]; then
    rm -rf ~/.oh-my-zsh # Delete old oh-my-zsh config.
    rm -f ~/.zcompdump*
fi

git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

# Use zsh as default
while true; do
  echo -e "${Gre}Do you whish to use zsh as your default shell? (Y/n)${RCol}"
  read yn
  case $yn in
    [Yy]* )
			chsh -s /bin/zsh
      break;;

    [Nn]* ) break;;
    * ) echo "Please answer yes or no.";;
  esac
done
# Copy .zshrc
export ZSH=$HOME/.oh-my-zsh
pwd
rm -rf ~/.zshrc
cp ../.zshrc ~/.zshrc
zsh


echo -e "${Gre} All done! Have a nice day :)${RCol}"
