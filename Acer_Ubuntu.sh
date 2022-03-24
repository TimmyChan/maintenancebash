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
apt-get install apt-transport-https


apt install software-properties-common -qy
add-apt-repository ppa:deadsnakes/ppa -y

# basics
apt install curl -qy
# https://github.com/cli/cli/blob/trunk/docs/install_linux.md
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
yes | echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
chmod 644 /usr/share/keyrings/githubcli-archive-keyring.gpg
chmod 644 /etc/apt/sources.list.d/github-cli.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys C99B11DEB97541F0

apt update
apt install gh

# LaTeX
apt install texlive-full -qy
apt install texmaker -qy


# Python Setup
apt install python3.9 -qy
update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1
update-alternatives --install /usr/bin/python python /usr/bin/python3.8 2
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 2

# https://stackoverflow.com/questions/13708180/python-dev-installation-error-importerror-no-module-named-apt-pkg
apt install --reinstall python3-pip python3.8-venv python3.9-venv python-apt python3-apt -qy
cp /usr/lib/python3/dist-packages/apt_pkg.cpython-38-x86_64-linux-gnu.so /usr/lib/python3/dist-packages/apt_pkg.so

# Jupyter Notebooks
# https://jupyter.org/install
# yes | pip install somepackage --quiet --exists-action ignore
# https://stackoverflow.com/questions/8400382/python-pip-silent-install
yes | python3.8 -m pip install jupyterlab --quiet 
yes | python3.8 -m pip install notebook --quiet 
yes | python3.9 -m pip install jupyterlab --quiet 
yes | python3.9 -m pip install notebook --quiet 

# Linter
apt install flake8 -qy

# SAGEmath
apt install sagemath -qy
apt install sagemath-jupyter -qy
apt install sagemath-doc-en -qy



##### BROWSER AND MEDIA #####
# Ubuntu extras
apt install ubuntu-restricted-extras gnome-tweaks -qy

# Google Chrome
apt install google-chrome-stable chrome-gnome-shell -qy  

# Compression
apt install rar unrar p7zip-full p7zip-rar -qy

# Making Gifs
apt install peek -qy

##### MAINTENANCE #####
# TLP - Optimize Linux Laptop Battery Life
apt install smartmontools -qy
# https://linrunner.de/tlp/
apt install tlp tlp-rdw -qy


# snap stuff
snap install discord 
snap install vlc  
snap install sublime-text --classic
snap install zoom-client
snap refresh 

# Acer_Spin_SP314 specific stuff
chmod +x Acer_Spin_SP314.sh
source ./Acer_Spin_SP314.sh

apt clean -qy
apt update -qy
apt upgrade -qy
apt autoremove -qy
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
tlp-stat > tlp-stat.log

##### Pushing to Git #####
git -C ${DIR} add .
git -C ${DIR} commit -m "${now}"
git -C ${DIR} push
