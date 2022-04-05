#!/usr/bin/bash
# This bash shell script is a maintenance and setup file for personal use
# Once run this script will add itself to crontab and run @reboot
# And also it pushes the directory to git. (entirely inspired by Github user @nodeadtree)

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

chmod +x ${DIR}/Git_Push_Now.sh
source ${DIR}/Git_Push_Now.sh

while getopts ":i" flag; do
  case $flag in
    i)
      echo "Initial Run Mode" >&2
      echo "Running Ubuntu Initial Setup..." >&2
      # Stuff that should only run one time.
      chmod +x ${DIR}/Ubuntu_Initial_Setup.sh 
      source ${DIR}/Ubuntu_Initial_Setup.sh


      echo "Running Acer_Spin_SP314 Setup..." >&2
      # Acer_Spin_SP314 specific stuff
      chmod +x ${DIR}/Acer_Spin_SP314.sh
      source ${DIR}/Acer_Spin_SP314.sh

      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

##### INITAL STEPS #####
# https://itsfoss.com/wrong-time-dual-boot/ (99% of my Ubuntu Setups are dual boot with Windows)
timedatectl set-local-rtc 1

snap refresh 
apt-get clean -qy
apt-get update -qy
apt-get autoremove -qy
apt-get -qy -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade
echo ""
echo ""
echo "Upkeep Complete!"
echo ""
echo "##########"
echo ""
echo ""

gitpushnow ${DIR}
