#!/bin/bash


# Common path
MOD_PATH=`pwd`/modules
CLI_PATH=/boot/cmdline.txt
INS_PATH=/lib/modules/`uname -r`/extra
KBUILD=/lib/modules/`uname -r`/build

# Check root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root (use sudo)" 1>&2
  exit 1;
fi

# Check headers
function check_kernel_headers() {
  RPI_HDR=/usr/src/linux-headers-`uname -r`

  if [ -d $RPI_HDR ]; then
	echo "Installed: $RPI_HDR"
	return 0;
  fi
  
  echo " !!! Your kernel version is `uname -r`"
  echo "     Couldn't find *** corresponding *** kernel headers with apt-get."
  echo "     This may happen if you ran 'rpi-update'."
  echo " Choose  *** y *** to install kernel-headers to version `uname -r` and continue."
  echo " Choose  *** N *** to exit without this driver support, by default."
  read -p "Would you like to proceed? (y/N)" -n 1 -r -s
  echo
  if ! [[ $REPLY =~ ^[Yy]$ ]]; then
    exit 1;
  fi

  apt-get -y install raspberrypi-kernel-headers
}

# Build module
function build_modules {
  if [ $# -eq 0 ]; then
    echo "No module to compile!"
	exit 1;
  fi

  for i
  do
    make -C $KBUILD M=$MOD_PATH/$i || echo Build failed: $i exit 1;
  done
}

function clean_modules {
  if [ $# -eq 0 ]; then
    echo "No module to clean!"
	exit 1;
  fi

  for i
  do
    make -C $KBUILD M=$MOD_PATH/$i clean || echo Clean failed: $i;
  done
}

# Install module
function install_modules {
  if [ $# -eq 0 ]; then
    echo "No module to install!"
	exit 1;
  fi
  
  mkdir -p $INS_PATH;

  for i
  do
    if [ -e $MOD_PATH/$i/$i.ko ]; then
      cp $MOD_PATH/$i/$i.ko $INS_PATH
	  grep -q "^$i$" /etc/modules || \
	    echo $i >> /etc/modules
	  echo Copied: $INS_PATH/$i.ko
	else
	  echo Not exist: $MOD_PATH/$i/$i.ko
	  exit 1;
	fi
  done
}

function uninstall_modules { 
  if [ $# -eq 0 ]; then
    echo "No module to uninstall!"
	exit 1;
  fi
  
  for i
  do
    if [ -e $INS_PATH/$i.ko ]; then
      rm -f $INS_PATH/$i.ko
	  echo Removed: $INS_PATH/$i.ko
    fi

	sed -i "/^"$i"$/d" /etc/modules
  done
}

# Add blacklist to cmdline
function add_blacklist {
  if [ $# -eq 0 ]; then
    echo "No module to add to blacklist!"
	exit 1;
  fi

  CMDLINE=$(cat $CLI_PATH | sed 's/\binitcall_blacklist=\S*\b *//g')
  BLACKLIST=$(grep -o "\binitcall_blacklist=\S*\b" $CLI_PATH)
  
  for i
  do
     if [ $(echo $BLACKLIST | grep -c "$i") -eq 0 ]; then
	   if [ ${#BLACKLIST} -eq 0 ]; then
	     BLACKLIST="initcall_blacklist=";
	   else
	     BLACKLIST="$BLACKLIST,";
	   fi
	   BLACKLIST="$BLACKLIST$i";
	 fi
  done
  
  CMDLINE="$CMDLINE $BLACKLIST"
  echo $CMDLINE > $CLI_PATH
}

function remove_blacklist {
  if [ $# -eq 0 ]; then
    echo "No module to remove from blacklist!"
	exit 1;
  fi
  
  CMDLINE=$(cat $CLI_PATH | sed 's/\binitcall_blacklist=\S*\b *//g')
  
  echo $CMDLINE > $CLI_PATH
}

function usage() {
  cat <<-__EOF__
    usage: sudo ./cm4_lan7800.sh [ --autoremove | --install ] [ -h | --help ]
             default action is update lan7800 module.
             --install       used for update module
             --autoremove    used for automatic cleaning
             --help          show this help message
__EOF__
  exit 1
}

function install() {
  check_kernel_headers
  build_modules lan7800
  install_modules lan7800
  add_blacklist lan78xx_driver_init

  echo "------------------------------------------------------"
  echo "Please reboot your device to apply all settings"
  echo "Enjoy!"
  echo "------------------------------------------------------"
}

if [[ ! -z $1 ]]; then
  if [ $1 = "--autoremove" ]; then
    clean_modules lan7800
	uninstall_modules lan7800
	remove_blacklist lan78xx_driver_init
  elif [ $1 = "--install" ]; then
    install
  else
    usage
  fi
else
  install
fi








