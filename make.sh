#!/bin/bash

##############################################
make distclean
clear


if [ "$(id -u)" = "0" ]; then
	echo ""
	echo "You are running as root. Do not do this, it is dangerous."
	echo "Aborting the build. Log in as a regular user and retry."
	echo ""
	exit 1
fi

##############################################

if [ "$1" == -h ] || [ "$1" == --help ]; then
	echo "Usage: $0 [Parameter1 Parameter2 ... Parameter6]"
	echo
	echo "Parameter 1     : target system"
	echo "Parameter 2     : Neutrino variant"
	echo "Parameter 3     : Toolchain gcc version"
	echo "Parameter 4     : optimization"
	echo "Parameter 5     : External LCD support"
	echo "Parameter 6     : Image layout single or multiboot"
	exit
fi

##############################################

echo "  ____ ___   ___  __  __ ___                             "
echo " |  _ \ _ \ / _ \ \ \/ // __|                            "
echo " | | | | | | (_| | >  < \__ \                            "
echo " |_| |_| |_|\__,_|/_/\_\|___/                            "
echo "  _           _ _     _               _                  "
echo " | |         (_) |   | |             | |                 "
echo " | |__  _   _ _| | __| |___ _   _ ___| |_____  ___ ___   "
echo " |  _ \| | | | | |/ _  / __| | | / __| __/ _ \/ _ v _ \  "
echo " | |_) | |_| | | | (_| \__ \ |_| \__ \ ||  __/ | | | | | "
echo " |_.__/\__,_\|_|_|\__,_|___/\__, |___/\__\___|_| |_| |_| "
echo "                             __/ |                       "
echo "                            |___/                        "

##############################################

case $1 in
	[1-9] | 1[0-9] | 2[0-9] | 3[0-9]) REPLY=$1;;
	*)
		echo "Target receivers:"
		echo ""
		echo "   1)  Neutrino PC generic"
		echo ""
		echo "  10)  VU+ Duo 4K"
		echo "  11)  VU+ Solo 4k"
		echo "  12)  VU+ Ultimo 4K"
		echo "  13)  VU+ Uno 4K"
		echo "  14)  VU+ Uno 4K SE"
		echo "  15)  VU+ Zero 4K"
		echo "  16)  VU+ Duo 4K SE"
		echo ""
		echo "  20)  WWIO BRE2ZE 4K"
		echo "  21)  AX/Mut@nt HD51"
		echo "  22)  AX/Mut@nt HD60"
		echo "  23)  AX/Mut@nt HD61"
		echo "  24)  AirDigital Zgemma H7C/H7S"
		echo "  25)  AXAS E4HD 4K Ultra"
		echo "  26)  Protek 4k"
		echo ""
		echo "  30)  Edision OS mio 4K"
		echo "  31)  Edision OS mio+ 4K"
		echo ""
		read -p "Select target? [21] "
		REPLY="${REPLY:-21}";;
esac

case "$REPLY" in
	 1) TARGET_ARCH="$(shell which arch > /dev/null 2>&1 && arch || uname -m)";BOXTYPE="generic";BOXMODEL="generic";;
	10) TARGET_ARCH="arm";BOXTYPE="armbox";BOXMODEL="vuduo4k";;
	11) TARGET_ARCH="arm";BOXTYPE="armbox";BOXMODEL="vusolo4k";;
	12) TARGET_ARCH="arm";BOXTYPE="armbox";BOXMODEL="vuultimo4k";;
	13) TARGET_ARCH="arm";BOXTYPE="armbox";BOXMODEL="vuuno4k";;
	14) TARGET_ARCH="arm";BOXTYPE="armbox";BOXMODEL="vuuno4kse";;
	15) TARGET_ARCH="arm";BOXTYPE="armbox";BOXMODEL="vuzero4k";;
	16) TARGET_ARCH="arm";BOXTYPE="armbox";BOXMODEL="vuduo4kse";;
	20) TARGET_ARCH="arm";BOXTYPE="armbox";BOXMODEL="bre2ze4k";;
	21) TARGET_ARCH="arm";BOXTYPE="armbox";BOXMODEL="hd51";;
	22) TARGET_ARCH="arm";BOXTYPE="armbox";BOXMODEL="hd60";;
	23) TARGET_ARCH="arm";BOXTYPE="armbox";BOXMODEL="hd61";;
	24) TARGET_ARCH="arm";BOXTYPE="armbox";BOXMODEL="h7";;
	25) TARGET_ARCH="arm";BOXTYPE="armbox";BOXMODEL="e4hdultra";;
	26) TARGET_ARCH="arm";BOXTYPE="armbox";BOXMODEL="protek4k";;
	30) TARGET_ARCH="arm";BOXTYPE="armbox";BOXMODEL="osmio4k";;
	31) TARGET_ARCH="arm";BOXTYPE="armbox";BOXMODEL="osmio4kplus";;
	 *) TARGET_ARCH="arm";BOXTYPE="armbox";BOXMODEL="hd51";;
esac
echo "TARGET_ARCH=$TARGET_ARCH" > .config
echo "BOXTYPE=$BOXTYPE" >> .config
echo "BOXMODEL=$BOXMODEL" >> .config

##############################################

if [ $BOXTYPE == 'generic' ]; then

echo "FLAVOUR=neutrino-max" >> .config

if [ $BOXMODEL == 'generic' ]; then
case $2 in
	[1-2]) REPLY=$2;;
	*)	echo -e "\nMedia Framework:"
		echo "   1)  mpv player"
		echo "   2)  gstreamer"
		read -p "Select media framework (1-2)? [1] "
		REPLY="${REPLY:-1}";;
esac

case "$REPLY" in
	1)  MEDIAFW="mpv-player";;
	2)  MEDIAFW="gstreamer";;
	*)  MEDIAFW="mpv-player";;
esac
echo "MEDIAFW=$MEDIAFW" >> .config
fi

##############################################

echo " "
make printenv
echo "Your next step could be:"
echo "  make neutrino-pc"
echo "  make neutrino-pc-gdb"
echo "  make neutrino-pc-valgrind"
echo " "

else

##############################################

case $2 in
	[1-6]) REPLY=$2;;
	*)	echo -e "\nWhich Neutrino variant do you want to build?:"
		echo "   1)  neutrino-ddt"
		echo "   2)  neutrino-max"
		echo "   3)  neutrino-ni"
		echo "   4)  neutrino-tangos"
		echo "   5)  neutrino-redblue"
		read -p "Select Image to build (1-5)? [2] "
		REPLY="${REPLY:-2}";;
esac

case "$REPLY" in
	1) FLAVOUR="neutrino-ddt";;
	2) FLAVOUR="neutrino-max";;
	3) FLAVOUR="neutrino-ni";;
	4) FLAVOUR="neutrino-tangos";;
	5) FLAVOUR="neutrino-redblue";;
	6) FLAVOUR="neutrino-max-test";;
	*) FLAVOUR="neutrino-max";;
esac
echo "FLAVOUR=$FLAVOUR" >> .config

##############################################

case $3 in
	[1-4]) REPLY=$3;;
	*)	echo -e "\nToolchain gcc version:"
		echo "   1) GCC version 6.5.0"
		echo "   2) GCC version 8.5.0"
		echo "   3) GCC version 13.2.0"
		echo "   4) GCC version 14.1.0"
		read -p "Select toolchain gcc version (1-4)? [2] "
		REPLY="${REPLY:-2}";;
esac

case "$REPLY" in
	1) GCC_VERSION="6.5.0";;
	2) GCC_VERSION="8.5.0";;
	3) GCC_VERSION="13.2.0";;
	4) GCC_VERSION="14.1.0";;
	*) GCC_VERSION="8.5.0";;
esac
echo "GCC_VERSION=$GCC_VERSION" >> .config

##############################################

case $4 in
	[1-3]) REPLY=$4;;
	*)	echo -e "\nOptimization:"
		echo "   1)  optimization for size"
		echo "   2)  optimization normal"
		echo "   3)  debug"
		read -p "Select optimization (1-3)? [1] "
		REPLY="${REPLY:-1}";;
esac

case "$REPLY" in
	1)  OPTIMIZATIONS="size";;
	2)  OPTIMIZATIONS="normal";;
	3)  OPTIMIZATIONS="debug";;
	*)  OPTIMIZATIONS="size";;
esac
echo "OPTIMIZATIONS=$OPTIMIZATIONS" >> .config

##############################################

case $5 in
	[1-4]) REPLY=$5;;
	*)	echo -e "\nExternal LCD support:"
		echo "   1)  No external LCD"
		echo "   2)  graphlcd for external LCD"
		echo "   3)  lcd4linux for external LCD"
		echo "   4)  graphlcd and lcd4linux for external LCD (both)"
		read -p "Select external LCD support (1-4)? [4] "
		REPLY="${REPLY:-4}";;
esac

case "$REPLY" in
	1) EXTERNAL_LCD="none";;
	2) EXTERNAL_LCD="graphlcd";;
	3) EXTERNAL_LCD="lcd4linux";;
	4) EXTERNAL_LCD="both";;
	*) EXTERNAL_LCD="both";;
esac
echo "EXTERNAL_LCD=$EXTERNAL_LCD" >> .config

##############################################

if [ $BOXMODEL == 'hd51' -o \
     $BOXMODEL == 'bre2ze4k' -o \
     $BOXMODEL == 'h7' \
    ]; then

case $6 in
	[1-3]) REPLY=$6;;
	*)	echo -e "\nImage-Layout:"
		echo "   1)  4 single"
		echo "   2)  1 single + multiroot"
		read -p "Select layout (1-2)? [2] "
		REPLY="${REPLY:-2}";;
esac

case "$REPLY" in
	1)  IMAGE_LAYOUT="single";;
	2)  IMAGE_LAYOUT="subdirboot";;
	*)  IMAGE_LAYOUT="subdirboot";;
esac
echo "IMAGE_LAYOUT=$IMAGE_LAYOUT" >> .config

fi

if [ $BOXMODEL == 'hd60' -o \
     $BOXMODEL == 'hd61' \
    ]; then
echo "IMAGE_LAYOUT=subdirboot" >> .config
fi

if [ $BOXMODEL == 'e4hdultra' -o \
     $BOXMODEL == 'protek4k' \
    ]; then
echo "IMAGE_LAYOUT=single" >> .config
fi

if [ $BOXMODEL == 'vuduo4k' -o \
     $BOXMODEL == 'vusolo4k' -o \
     $BOXMODEL == 'vuultimo4k' -o \
     $BOXMODEL == 'vuuno4k' -o \
     $BOXMODEL == 'vuuno4kse' -o \
     $BOXMODEL == 'vuzero4k' -o \
     $BOXMODEL == 'vuduo4kse' \
    ]; then

	case $6 in
		[1-2]) REPLY=$6;;
		*)	echo -e "\nNormal or MultiBoot:"
			echo "   1)  Normal"
			echo "   2)  Multiboot"
			read -p "Select mode (1-2)? [2] ";;
	esac

	case "$REPLY" in
	1)  VU_MULTIBOOT="0";;
	2)  VU_MULTIBOOT="1";;
	*)  VU_MULTIBOOT="1";;
	esac
	echo "VU_MULTIBOOT=$VU_MULTIBOOT" >> .config
fi

##############################################

echo " "
make printenv
echo "Your next step could be:"
echo "  make flashimage"
echo "  make ofgimage"
echo " "

fi
