#!/usr/bin/bash
# This bash shell script is a maintenance and setup file for personal use
# Once run this script will add itself to crontab and run @reboot
# And also it pushes the directory to git. (entirely inspired by Github user @nodeadtree)
# Please note that besides running this file,
# one should setup github authentication using HTTPS for the repo for this trick to work,
# some weird things happen if you try to use SSH in root. 

# UBUNTU 20.04 LTS
# https://linuxhint.com/40_things_after_installing_ubuntu/
# https://www.cyberciti.biz/faq/explain-debian_frontend-apt-get-variable-for-ubuntu-debian/

export NEEDRESTART_MODE=a
export DEBIAN_FRONTEND=noninteractive
export DEBIAN_PRIORITY=critical

SOURCE=${BASH_SOURCE[0]}
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

##### INITAL STEPS #####
# https://itsfoss.com/wrong-time-dual-boot/ (99% of my Ubuntu Setups are dual boot with Windows)
timedatectl set-local-rtc 1
apt clean -qy
apt-get install apt-transport-https
apt update -qy
apt -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade -qy 

apt install software-properties-common -qy
add-apt-repository ppa:deadsnakes/ppa -y

apt install curl -qy

# Python Setup
apt install python3.9 -qy
update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1
update-alternatives --install /usr/bin/python python /usr/bin/python3.8 2
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 2

# https://stackoverflow.com/questions/13708180/python-dev-installation-error-importerror-no-module-named-apt-pkg
apt install --reinstall python3-pip python3.8-venv python3.9-venv python-apt python3-apt -qy
cp /usr/lib/python3/dist-packages/apt_pkg.cpython-38-x86_64-linux-gnu.so /usr/lib/python3/dist-packages/apt_pkg.so

# Linter
apt install flake8 -qy

# Ubuntu extras
echo "Installing Ubuntu extras..."
apt install ubuntu-restricted-extras gnome-tweaks -qy

##### BROWSER AND MEDIA #####
# Google Chrome
apt install google-chrome-stable chrome-gnome-shell -qy  

# Compression
apt install rar unrar p7zip-full p7zip-rar -qy

# Making Gifs
apt install peek -qy

##### MAINTENANCE #####
# TLP - Optimize Linux Laptop Battery Life
# https://linrunner.de/tlp/
apt install tlp tlp-rdw -qy


# snap stuff
snap install vlc 
snap install sublime-text --classic
snap install gh

# Acer Spin SP314 Specific
# https://www.gnu.org/software/sed/manual/sed.html
# https://ubuntuforums.org/showthread.php?t=2450981
# https://sciactive.com/2020/12/04/how-to-install-ubuntu-on-acer-spin-5-sp513-54n-for-the-perfect-linux-2-in-1/
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash i8042.nopnp=1 pci=nocrs"/' /etc/default/grub
update-grub

apt -qy update 
apt -qy -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade
echo ""
echo ""
echo "Upkeep Complete!"
echo ""
echo "##########"
echo ""
echo ""

##### ADDING TO CRONJOB #####
# https://fedingo.com/how-to-create-cron-job-using-shell-script/
# https://askubuntu.com/questions/893911/when-writing-a-bash-script-how-do-i-get-the-absolute-path-of-the-location-of-th


crontab -l > cron_bkp
# TODO: change the following line to SED or something less destructive for wider use lols 
echo "@reboot sleep 60 && export DISPLAY=:0 && $(realpath "$0") > ${DIR}/out.log 2>&1"  > cron_bkp
crontab cron_bkp
rm cron_bkp

crontab -l

now=`date`
echo $now > ${DIR}/last_run.txt

##### Pushing to Git #####
git -C ${DIR} add .
git -C ${DIR} commit -m "${now}"
git -C ${DIR} push
