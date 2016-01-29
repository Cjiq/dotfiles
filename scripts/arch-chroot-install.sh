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

# Setup install functions
rootcheck () {
  if [[ $EUID -ne 0 ]]; then
    echo "You must be a root user" 2>&1
    exit 1
  fi
}
# Setup install variables

cr=`echo $'\n.'`
cr=${cr%.}

# Pick a hostname
echo -e -n "${Cya}Please enter a hostname?${RCol} (Default arch)${cr}Use:" 
read -e -p " " -i "arch" input
INSTALL_HOSTNAME=$input
echo $INSTALL_HOSTNAME > /etc/hostname
# Enter zoneinfo
while true; do
    echo -e -n "${Cya}Is ${Gre}Europe/Stockholm${Cya} your current timezone?${RCol} (Y/n) "
    read yn
    case $yn in
        [Yy]* )
            ln -s /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
            break;
            ;;
        [Nn]* )
            echo -e -n "${Cya}Please enter your preferred timezone.${RCol} (e.g Europe/Stockholm)${cr}Use:" 
            read -e -p " " -i "Europe/Stockholm" input
            ln -s /usr/share/zoneinfo/$input /etc/localtime
            break;;
        * ) echo "Please answer yes or no.";;
    esac
done
# Select locale
echo -e -n "${Cya}Please enter your preferred language.${RCol} (Default en_US.UTF-8)${cr}Use:" 
read -e -p " " -i "en_US.UTF-8" input
INSTALL_LANGUAGE=$input
echo "LANG=$INSTALL_LANGUAGE" > /etc/locale.conf
cp /etc/locale.gen /etc/locale.gen.bak
echo "$INSTALL_LANGUAGE UTF-8" > /etc/locale.gen
locale-gen
rm -f /etc/locale.gen
mv /etc/locale.gen.bak /etc/locale.gen
# Select keyboard layout
while true; do
    echo -e -n "${Cya}Are you using a standard swedish keyboard?${cr}If so ${Gre}sv-latin1${Cya} will be used as you keyboard layout.${RCol} (Y/n) "
    read yn
    case $yn in
        [Yy]* )
            INSTALL_KEYBOARD_LAYOUT="sv-latin1"
            echo $INSTALL_KEYBOARD_LAYOUT > /etc/vconsole.conf
            break;
            ;;
        [Nn]* )
            echo -e -n "${Cya}Please enter your preferred keyboard layout.${RCol} (Default sv-latin1)${cr}Use:" 
            read -e -p " " -i "sv-latin1" input
            INSTALL_KEYBOARD_LAYOUT=$input
            echo $INSTALL_KEYBOARD_LAYOUT > /etc/vconsole.conf
            break;;
        * ) echo "Please answer yes or no.";;
    esac
done
# # Create initial ramdisk environment
# arch-chroot  mkinitcpio -p linux
# # Install grub
# arch-chroot  grub-install --recheck --target=i386-pc $INSTALL_DRIVE
# arch-chroot  grub-mkconfig -o /boot/grub/grub.cfg

postInstallation()
{
    while true; do
        echo -e -n "${Cya}Do you wish to create a new user account?${RCol} (Y/n) "
        read yn
        case $yn in
            [Yy]* )
                echo -e -n "${Cya}Please enter your preferred user name.${RCol} (Default archi)${cr}Use:" 
                read -e -p " " -i "archi" input
                INSTALL_USER_NAME=$input
                echo -e -n "${Cya}Please enter your preferred groups.${RCol} (Default wheel,uucp)${cr}Use:" 
                read -e -p " " -i "wheel,uucp" input
                INSTALL_USER_GROUPS=$input
                echo -e -n "${Cya}Please enter your preferred shell.${RCol} (Default /bin/bash)${cr}Use:" 
                read -e -p " " -i "/bin/bash" input
                INSTALL_USER_SHELL=$input
                useradd -m -G $INSTALL_USER_GROUPS -s $INSTALL_USER_SHELL $INSTALL_USER_NAME
                break;
                ;;
            [Nn]* )
                break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
    while true; do
        echo -e -n "${Cya}Do you wish to configure sudo?${RCol} (Y/n) "
        read yn
        case $yn in
            [Yy]* )
                while true; do
                    echo -e -n "${Cya}Are you familiar with vi?${RCol} (Y/n) "
                    read yn
                    case $yn in
                        [Yy]* )
                            visudo
                            break;
                            ;;
                        [Nn]* )
                            nano /etc/sudoers
                            break;;
                        * ) echo "Please answer yes or no.";;
                    esac
                done
                break;
                ;;
            [Nn]* )
                break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
    while true; do
        echo -e -n "${Cya}Do you wish to configure video and install a display environment like gnome?${RCol} (Y/n) "
        read yn
        case $yn in
            [Yy]* )
                while true; do
                    echo -e -n "${Cya}Are you installing in VirtualBox?${RCol} (Y/n) "
                    read yn
                    case $yn in
                        [Yy]* )
                            pacman -S --noconfirm xf86-video-vesa xorg-server xorg-server-utils
                            pacman -S --noconfirm virtualbox-guest-utils
                            pacman -S --noconfirm virtualbox-guest-modules
                            pacman -S --noconfirm virtualbox-guest-modules-lts
                            pacman -S --noconfirm virtualbox-guest-dkms
                            echo "vboxguest" > /etc/modules-load.d/virtualbox.conf
                            echo "vboxsf" >> /etc/modules-load.d/virtualbox.conf
                            echo "vboxvideo" >> /etc/modules-load.d/virtualbox.conf
                            systemctl enable vboxservice.service
                            break;
                            ;;
                        [Nn]* )
                            break;;
                        * ) echo "Please answer yes or no.";;
                    esac
                done
                while true; do
                    echo -e -n "${Cya}Do you whish to install gnome?${RCol} (Y/n) "
                    read yn
                    case $yn in
                        [Yy]* )
                            pacman -S --noconfirm gnome gdm
                            systemctl enable gdm.service
                            break;
                            ;;
                        [Nn]* )
                            while true; do
                                echo -e "${Cya}Sorry, no other desktop environments are currently supported by this script. ${Red}:(${Cya}"
                                echo -e -n "${Cya}Do you want to install gnome anyways?${RCol} (Y/n) "
                                read yn
                                case $yn in
                                    [Yy]* )
                                        break;
                                        ;;
                                    [Nn]* )
                                        break 2;;
                                    * ) echo "Please answer yes or no.";;
                                esac
                            done
                            ;;
                        * ) echo "Please answer yes or no.";;
                    esac
                done

                break;
                ;;
            [Nn]* )
                break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
    echo -e "${Cya}PostInstallation is now completed! Yey! Your computer will now restart. ${RCol}"
}

while true; do
    echo -e -n "${Cya}Installation is now completed! Yey! ${Gre}:D${Cya}${cr}Do you wish to do some post installation stuff or just exit script?${RCol} (Y/n) "
    read yn
    case $yn in
        [Yy]* )
            postInstallation
            break;
            ;;
        [Nn]* )
 echo "           break;;
   "     *  echo "Please answer yes or no.";;
    esac
done
