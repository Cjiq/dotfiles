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

INSTALL_DRIVE=/dev/sda
cr=`echo $'\n.'`
cr=${cr%.}

# Check root!
rootcheck
# Fetch arch-chroot-install.sh
wget https://raw.githubusercontent.com/Cjiq/dotfiles/master/scripts/arch-chroot-install.sh -O arch-chroot-install.sh
echo -e -n "${Cya}Which /dev/sdx do you which to use?${RCol} (Default /dev/sda)${cr}Use:" 

# Prompt user for correct harddrive
read -e -p " " input
input=${input:-/dev/sda}
INSTALL_DRIVE=$input

echo -e -n "${Cya}Which /dev/sda{x} number do you wish to start at?${RCol} (Default /dev/sda2)${cr}Use:" 

# Prompt user for correct sda number
read -e -p " " SDA_NUMBER
SDA_NUMBER=${SDA_NUMBER:-2}

# Set default partition setup
BOOT_PARTITION=${INSTALL_DRIVE}${SDA_NUMBER}
SDA_NUMBER=$((SDA_NUMBER+1))
ROOT_PARTITION=${INSTALL_DRIVE}${SDA_NUMBER}
SDA_NUMBER=$((SDA_NUMBER+1))
SWAP_PARTITION=${INSTALL_DRIVE}${SDA_NUMBER}
SDA_NUMBER=$((SDA_NUMBER+1))
HOME_PARTITION=${INSTALL_DRIVE}${SDA_NUMBER}

# Start gdisk with chosen harddrive
echo -e "${Cya}Starting gdisk with ${Gre}$INSTALL_DRIVE${Cya} for manual partitioning${RCol}"
echo -e "${Cya}This is my recommended and default partition setup${RCol}"
echo -e "+-----------+------+-------+-------+"
echo -e "| Partition | Size | Usage | Code  |"
echo -e "|-----------+------+-------|-------|"
echo -e "|     1     | 84K  |  -    | EF02  |"
echo -e "|     2     | 250M | /boot | 8300  |"
echo -e "|     3     | 10G  | /     | 8300  |"
echo -e "|     4     | RAM*1| swap  | 8200  |"
echo -e "|     5     | rest | /home | 8300  |"
echo -e "+-----------+------+-------+-------+"
gdisk $INSTALL_DRIVE
handleCustomPartition()
{
    while true; do
        echo -e -n "${Cya}Custom boot partition?${RCol} (Y/n) "
        read yn
        case $yn in
            [Yy]* )
                echo -e -n "${Cya}Which partition did you pick as your boot partition?${RCol} (Default ${INSTALL_DRIVE}2)${cr}Use:" 
                read -e -p " " -i "${INSTALL_DRIVE}2" input
                BOOT_PARTITION=$input
                break;
                ;;
            [Nn]* )
                BOOT_PARTITION=""
                break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
    while true; do
        echo -e -n "${Cya}Custom root partition?${RCol} (Y/n) "
        read yn
        case $yn in
            [Yy]* )
                echo -e -n "${Cya}Which partition did you pick as your root partition?${RCol} (Default ${INSTALL_DRIVE}3)${cr}Use:" 
                read -e -p " " -i "${INSTALL_DRIVE}3" input
                ROOT_PARTITION=$input
                break;
                ;;
            [Nn]* )
                ROOT_PARTITION=""
                break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
    while true; do
        echo -e -n "${Cya}Custom swap partition?${RCol} (Y/n) "
        read yn
        case $yn in
            [Yy]* )
                echo -e -n "${Cya}Which partition did you pick as your swap partition?${RCol} (Default ${INSTALL_DRIVE}4)${cr}Use:" 
                read -e -p " " -i "${INSTALL_DRIVE}4" input
                SWAP_PARTITION=$input
                break;
                ;;
            [Nn]* )
                SWAP_PARTITION=""
                break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
    while true; do
        echo -e -n "${Cya}Custom home partition?${RCol} (Y/n) "
        read yn
        case $yn in
            [Yy]* )
                echo -e -n "${Cya}Which partition did you pick as your home partition?${RCol} (Default ${INSTALL_DRIVE}5)${cr}Use:" 
                read -e -p " " -i "${INSTALL_DRIVE}5" input
                HOME_PARTITION=$input
                break;
                ;;
            [Nn]* )
                HOME_PARTITION=""
                break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}
while true; do
    echo -e -n "${Cya}Did you partition according to my setup? If not you will have to input some extra configuration.${RCol} (Y/n) "
    read yn
    case $yn in
        [Yy]* )
            
            break;;
        [Nn]* ) handleCustomPartition;break;;
        * ) echo "Please answer yes or no.";;
    esac
done

mkfs.ext4 $ROOT_PARTITION
mkdir -p /mnt
mount $ROOT_PARTITION /mnt
if [[ ! -z "$BOOT_PARTITION" ]]; then
    mkfs.ext4 $BOOT_PARTITION
    mkdir /mnt/boot
    mount $BOOT_PARTITION /mnt/boot
fi
if [[ ! -z "$HOME_PARTITION" ]]; then
    mkfs.ext4 $HOME_PARTITION
    mkdir /mnt/home
    mount $HOME_PARTITION /mnt/home
fi
if [[ ! -z "$SWAP_PARTITION" ]]; then
    mkswap $SWAP_PARTITION
    swapon $SWAP_PARTITION
fi

while true; do
    echo -e -n "${Cya}Do you whish to optimise the installer mirrors according to your current location?${RCol} (Y/n) " 
    read yn
    case $yn in
        [Yy]* )
            while true; do
                echo -e -n "${Cya}Are you in ${Gre}Sweden?${RCol} (Y/n) " 
                read yn
                case $yn in
                    [Yy]* )
                        MIRRORLIST=true
                        cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak 

                        echo "Server = http://ftp.lysator.liu.se/pub/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist
                        echo "Server = http://archlinux.dynamict.se/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
                        echo "Server = http://mirror.yandex.ru/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
                        echo "Server = http://ftp.acc.umu.se/mirror/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
                        echo "Server = http://mirror.neuf.no/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
                        echo "Server = http://mirrors.atviras.lt/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
                        pacman -Syyu
                        break;;
                    [Nn]* )
                        echo -e -n "${Cya}Sorry this script does not support any ther countries atm.${RCol} (Y/n) " 
                        break;;
                    * ) echo "Please answer yes or no.";;
                esac
            done
            break;;
        [Nn]* )
            break;;
        * ) echo "Please answer yes or no.";;
    esac
done
echo -e -n "${Cya}Downloading and Installing system! ${Gre}:D${RCol}${cr}" 
pacstrap /mnt base base-devel
arch-chroot /mnt pacman -S --noconfirm grub-bios syslinux sudo openssh vim dialog wpa_supplicant
genfstab -p /mnt >> /mnt/etc/fstab
# # Create initial ramdisk environment
arch-chroot /mnt mkinitcpio -p linux
# Install grub
arch-chroot /mnt grub-install --recheck --target=i386-pc $INSTALL_DRIVE
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
# arch-chroot fix -----
# copy arch-chroot-install.sh /mnt/ execute it and remove on finish.
cp arch-chroot-install.sh /mnt/
if [[ ! -z "$MIRRORLIST" ]]; then
    cp -rf /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist
fi
arch-chroot /mnt chmod +x arch-chroot-install.sh
arch-chroot /mnt ./arch-chroot-install.sh
rm -f /mnt/arch-chroot-install.sh

# Done. Exit out of chroot and unmount everything
if [[ ! -z "$BOOT_PARTITION" ]]; then
    umount $BOOT_PARTITION
fi
if [[ ! -z "$HOME_PARTITION" ]]; then
    umount $HOME_PARTITION
fi
if [[ ! -z "$SWAP_PARTITION" ]]; then
    swapoff $SWAP_PARTITION
fi
umount $ROOT_PARTITION
reboot
