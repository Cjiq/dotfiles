#!/bin/bash

# Load some setup variables
source "${BASH_SOURCE%/*}/prepare.sh"

# 1. Download zsh.
# 2. Copy .zshrc
# 3. Install plugins.
# 4. Ask to set zsh as default shell.

cur_user=$(whoami)

while true; do
  echo -e "${Gre}This script will download zsh and overwirte your old .zshrc config. Do you whish to continue? (Y/n)${RCol}"
  read yn
  case $yn in
    [Yy]* ) break;;
    [Nn]* ) exit;;
    * ) echo "Please answer yes or no.";;
  esac
done

echo -e "Installing zsh.. "
if [[ "$OSTYPE" == "darwin"* ]]; then
		brew install zsh
elif [[ $DIST == "centos" ]]; then
		sudo yum install -y zsh > /dev/null
elif [[ $DIST == "Ubuntu" ]]; then
		sudo apt-get install -y zsh > /dev/null
elif [[ $DIST == "arch" ]]; then
		sudo pacman -S --noconfirm --needed zsh > /dev/null
fi

# Install oh-my-zsh
if [ ! -n "$ZSH" ]; then
    ZSH=~/.oh-my-zsh
fi

if [ -d "$ZSH" ]; then
    rm -rf ~/.oh-my-zsh # Delete old oh-my-zsh config.
    rm -f ~/.zcompdump*
fi

echo -e "Downloading oh-my-zsh.."
git clone --quiet git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh > /dev/null

echo -e "Downloading zsh-autosuggestions.."
git clone --quiet https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions > /dev/null

echo -e "Installing zplug"
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

# Use zsh as default
while true; do
  echo -e "${Gre}Do you whish to use zsh as your default shell? (Y/n)${RCol}"
  read yn
  case $yn in
    [Yy]* )
			sudo chsh -s /bin/zsh $cur_user
      break;;

    [Nn]* ) break;;
    * ) echo "Please answer yes or no.";;
  esac
done
# Copy .zshrc
export ZSH=$HOME/.oh-my-zsh
pwd
rm -rf ~/.zshrc
ln -s "$HOME/.dotfiles/.zshrc" ~/.zshrc

echo -e "${Gre} All done! Have a nice day :)${RCol}"
zsh
