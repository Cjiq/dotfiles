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

echo -e -n "${Cya}Which /dev/sdx do you which to use?${RCol} (Default /dev/sda)${cr}Use:" 

# Prompt user for correct harddrive
read -e -p " " -i "/dev/sda" input
INSTALL_DRIVE=$input

# Set default partition setup
BOOT_PARTITION=${INSTALL_DRIVE}2
ROOT_PARTITION=${INSTALL_DRIVE}3
SWAP_PARTITION=${INSTALL_DRIVE}4
HOME_PARTITION=${INSTALL_DRIVE}5

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
        read -p "Custom boot partition? (Y/n) " yn
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
        read -p "Custom root partition? (Y/n) " yn
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
        read -p "Custom swap partition? (Y/n) " yn
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
        read -p "Custom home partition? (Y/n) " yn
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
    read -p "Did you partition according to my setup? If not you will have to input some extra configuration. (Y/n) " yn
    case $yn in
        [Yy]* )
            
            break;;
        [Nn]* ) handleCustomPartition;break;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "mkfs.ext4 $ROOT_PARTITION"
echo "mkdir -p /mnt"
echo "mount $ROOT_PARTITION /mnt"
if [[ ! -z "$BOOT_PARTITION" ]]; then
    echo "   mkfs.ext4 $BOOT_PARTITION"
    echo "   mkdir /mnt/boot"
    echo "   mount $BOOT_PARTITION /mnt/boot"
fi
if [[ ! -z "$HOME_PARTITION" ]]; then
    echo "   mkfs.ext4 $HOME_PARTITION"
    echo "   mkdir /mnt/home"
    echo "   mount $HOME_PARTITION /mnt/home"
fi
if [[ ! -z "$SWAP_PARTITION" ]]; then
    echo "   mkswap $SWAP_PARTITION"
    echo "   swapon $SWAP_PARTITION"
fi
echo -e -n "${Cya}Installing system! ${Gre}:D${RCol}${cr}" 
echo "pacstrap /mnt base base-devel"
echo "arch-chroot /mnt pacman -S --noconfirm grub-bios syslinux"
echo "genfstab -p /mnt >> /mnt/etc/fstab"
echo "arch-chroot /mnt /bin/bash"
# Pick a hostname
echo -e -n "${Cya}Please enter a hostname?${RCol} (Default arch)${cr}Use:" 
read -e -p " " -i "arch" input
INSTALL_HOSTNAME=$input
echo "echo $INSTALL_HOSTNAME > /etc/hostname"
# Enter zoneinfo
while true; do
    echo -e -n "${Cya}Is ${Gre}Europe/Stockholm${Cya} your current timezone?${RCol} (Y/n) "
    read yn
    case $yn in
        [Yy]* )
            echo "ln -s /usr/share/zoneinfo/Europe/Stockholm /etc/localtime"
            break;
            ;;
        [Nn]* )
            echo -e -n "${Cya}Please enter your preferred timezone.${RCol} (e.g Europe/Stockholm)${cr}Use:" 
            read -e -p " " -i "Europe/Stockholm" input
            echo "ln -s /usr/share/zoneinfo/$input /etc/localtime"
            break;;
        * ) echo "Please answer yes or no.";;
    esac
done

