#!/bin/bash

local commandname="UPDATE"
local commandaction="Update"
local function_selfname="$(basename "$(readlink -f "${BASH_SOURCE[0]}")")"

check_ip.sh
check.sh

# ==> MODIFY THIS

#What user you want to use (default: anonymous)
STEAM_USER=JediNarwals

#If you are not using anonymous, specify a password here.
STEAM_PASS=Sn168711

#The default location of the server, relative to this script (default: server).
#If no directory is specified for the server, it'll fall back on this one.
#Don't add a trailing /
INSTALL_DIR=serverfiles

#The location of the SteamCMD, relative to this script (default: bin). Don't add a trailing /
STEAM_DIR=steamcmd

#Ids of the servers you want to install, leave empty to skip
#First item is the directory, second item is the AppID. Directory is relative to script directory
DL_DIR0=
DL_SV0=233780
DL_GNM0="Arma 3"

DL_DIR1=
DL_SV1=

DL_DIR2=
DL_SV2=

DL_DIR3=
DL_SV3=

DL_DIR4=
DL_SV4=

DL_DIR5=
DL_SV5=

DL_DIR6=
DL_SV6=

DL_DIR7=
DL_SV7=

#Ids of the mods you want to install, leave empty to skip
#First item is the directory, second item is the AppID. Directory is relative to script directory
DL_NM0="@ace"
DL_MD0=463939057

DL_NM1="@aceplc"
DL_MD1=866772689

DL_NM2="@aceani"
DL_MD2=766491311

DL_NM3="@acex"
DL_MD3=708250744

DL_NM4="@advancedrappelling"
DL_MD4=713709341

DL_NM5="@advancedslingloading"
DL_MD5=615007497

DL_NM6="@advancedtowing"
DL_MD6=639837898

DL_NM7="@advancedurbanrappelling"
DL_MD7=730310357

DL_NM8="@backpackonchest"
DL_MD8=820924072

DL_NM9="@cba_a3"
DL_MD9=450814997

DL_NM10="@fa18superhornet"
DL_MD10=743099837

DL_NM11="@sma"
DL_MD11=699630614

DL_NM12="@enhancedmovement"
DL_MD12=333310405

DL_NM13="@task_force_radio"
DL_MD13=620019431

DL_NM14="@mcc"
DL_MD14=338988835

DL_NM15="@rhsusaf"
DL_MD15=843577117

DL_NM16="@rhsafrf"
DL_MD16=843425103

DL_NM17="@projectopfor"
DL_MD17=735566597

DL_NM18="@shacktacui"
DL_MD18=498740884

DL_NM19="@cupterrainscore"
DL_MD19=583496184

DL_NM20="@cupterrainsmaps"
DL_MD20=583544987

DL_NM21="@claclafghan"
DL_MD21=761349672

DL_NM22="@gosalrayak"
DL_MD22=648172507

DL_NM23="@gosnziwasogo"
DL_MD23=694603075

DL_NM24="@hazarkotvalley"
DL_MD24=766294759

DL_NM25="@asrai3"
DL_MD25=642457233

DL_NM26="@achilles"
DL_MD26=723217262

DL_NM27="@vsmaio"
DL_MD27=823636749

DL_NM28="@acecomptafrf"
DL_MD28=773131200

DL_NM29="@acecomptusaf"
DL_MD29=773125288

#Repeat this and the call to add_game at the bottom of this
#script to add more servers

# ==> (optional) INTERNAL SETTINGS, MODIFY IF REQUIRED

STEAMCMD_URL="http://media.steampowered.com/client/steamcmd_linux.tar.gz"
STEAMCMD_TARBALL="steamcmd_linux.tar.gz"

#
#	Don't modify below here, unless you know what you're doing.
#

clear
echo "================================="
echo ""
echo "updateserver.sh"
echo "Linux Game Server/Mod updater"
echo "by JediNarwals"
echo "Made for EuroForce"
echo "Integrated with LGSM"
echo ""
echo "================================="
echo ""

#This will stop the server in preperation of the validation process.
./arma3server stop

#Get the current directory (snippet from SourceCMD's sourcecmd.sh)
BASE_DIR="$(cd "${0%/*}" && echo $PWD)"

#Relocate downloads to absolute url
INSTALL_DIR=$BASE_DIR/$INSTALL_DIR
STEAM_DIR=$BASE_DIR/$STEAM_DIR

if [ -z "$BASE_DIR" -o -z "$INSTALL_DIR" -o -z "$STEAM_DIR" ]; then
	echo "Base directory, Install directory or SteamCMD directory is empty."
	echo "Please check if lines 14 and 17 have content behind the = sign."
	exit 1
fi

if [ ! -e "$STEAM_DIR" ]; then
        mkdir $STEAM_DIR
        MADEDIR=$?
        if [ "$MADEDIR" != "0" ]; then
		echo -e "[ \e[0;91mERROR\e[0m ] Failed to make directory for Steam. Do you have sufficient priviliges?"
		exit 1
	fi
	cd $STEAM_DIR
	echo "Fetching SteamCMD from servers..."
	wget $STEAMCMD_URL
	if [ ! -e "$STEAMCMD_TARBALL" ]; then
		echo -e "[ \e[0;91mERROR\e[0m ] Failed to get SteamCMD"
		exit 1
	fi
	echo "Completed. Extracting file..."

	#Hide the output
	(tar -xvzf $STEAMCMD_TARBALL)

	#Install SteamCMD now and try to login, if required
	if [ "$STEAM_USER" != "anonymous" ]; then
		$STEAM_DIR/steamcmd.sh +login $STEAM_USER $STEAM_PASS +quit
	else
		$STEAM_DIR/steamcmd.sh +quit
	fi
fi

cd $BASE_DIR

CmdArgs="+login $STEAM_USER $STEAM_PASS"
ShouldRun=0

add_game(){
	GAME="$1"
	DIR="$2"
	NAME="$3"
	if [ ! -z "$GAME" ]; then
		if [ -z "$DIR" ]; then
			DIR=$INSTALL_DIR
		else
			DIR=$BASE_DIR/$DIR
		fi

		OK=0
		if [ ! -d "$DIR" ]; then
			echo -e "[ \e[0;91;43m$3\e[0m ] Creating directory $DIR..."
			(mkdir $DIR)
			if [ ! -d "$DIR" ]; then
				OK=1
			fi
		fi
		if [ "$OK" == "0" ]; then
			#echo "Validating install in $DIR..."
			CmdArgs="$CmdArgs +force_install_dir \"$DIR\" +app_update $GAME validate"
			ShouldRun=1
			echo -e "[ \e[0;32m$3\e[0m ] Game Loaded!"
		else
			echo -e "[ \e[0;91;43m$3\e[0m ] Cannot add AppId $GAME into $DIR. Failed to create directory"
		fi
	fi
	alert="update"
	alert.sh
}

add_game "$DL_SV0" "$DL_DIR0" "$DL_GNM0"

add_mod(){
	MOD="$1"
	DIR="$2"
	if [ ! -z "$MOD" ]; then
		if [ -z "$DIR" ]; then
			DIR=$INSTALL_DIR
		else
			DIR=$BASE_DIR/$DIR
		fi

		OK=0
		if [ ! -d "$DIR" ]; then
			#echo -e "[ \e[0;31m$2\e[0m ] Creating directory $DIR..."
			(mkdir $DIR)
			if [ ! -d "$DIR" ]; then
				OK=1
			fi
		fi
		if [ "$OK" == "0" ]; then
			CmdArgs="$CmdArgs +force_install_dir \"$DIR\" +workshop_download_item 107410 $MOD validate"
			ShouldRun=1
      exitcode=$?
      if [ ${exitcode} -ne 0 ]; then
        echo -e "[ \e[0;31m$2\e[0m ] Mod Not Loaded!"
        exit 1
      else
        echo -e "[ \e[0;32m$2\e[0m ] Mod Loaded!"
      fi
			#echo -e "[ \e[0;32m$2\e[0m ] Mod Loaded!"
		#else
			#echo -e "[ \e[0;91;43m$2\e[0m ] Cannot add AppId $MOD into $DIR. Failed to create directory"
		fi
	fi
}

add_mod "$DL_MD0" "$DL_NM0"
add_mod "$DL_MD1" "$DL_NM1"
add_mod "$DL_MD2" "$DL_NM2"
add_mod "$DL_MD3" "$DL_NM3"
add_mod "$DL_MD4" "$DL_NM4"
add_mod "$DL_MD5" "$DL_NM5"
add_mod "$DL_MD6" "$DL_NM6"
add_mod "$DL_MD7" "$DL_NM7"
add_mod "$DL_MD8" "$DL_NM8"
add_mod "$DL_MD9" "$DL_NM9"
add_mod "$DL_MD10" "$DL_NM10"
add_mod "$DL_MD11" "$DL_NM11"
add_mod "$DL_MD12" "$DL_NM12"
add_mod "$DL_MD13" "$DL_NM13"
add_mod "$DL_MD14" "$DL_NM14"
add_mod "$DL_MD15" "$DL_NM15"
add_mod "$DL_MD16" "$DL_NM16"
add_mod "$DL_MD17" "$DL_NM17"
add_mod "$DL_MD18" "$DL_NM18"
add_mod "$DL_MD19" "$DL_NM19"
add_mod "$DL_MD20" "$DL_NM20"
add_mod "$DL_MD21" "$DL_NM21"
add_mod "$DL_MD22" "$DL_NM22"
add_mod "$DL_MD23" "$DL_NM23"
add_mod "$DL_MD24" "$DL_NM24"
add_mod "$DL_MD25" "$DL_NM25"
add_mod "$DL_MD26" "$DL_NM26"
add_mod "$DL_MD27" "$DL_NM27"
add_mod "$DL_MD28" "$DL_NM28"
add_mod "$DL_MD29" "$DL_NM29"

CmdArgs="$CmdArgs +quit"

if [ "$ShouldRun" == "0" ]; then
	echo -e "[ \e[0;43mERROR\e[0m ] No game IDs specified. Please specify at least one id"
	exit 1
fi

cd "$BASE_DIR"

#Workaround for SteamCMD continuously re-installing apps
echo "cd \"$BASE_DIR\"" > call.sh
echo "$STEAM_DIR/steamcmd.sh $CmdArgs" >> call.sh
chmod u+x ./call.sh
./call.sh
rm call.sh

echo "OK! Completed updating files!"

echo "Starting Mod moving..."

add_move(){
MOD="$1"
DIR_MOD="$2"

	if [ ! -z "$MOD" ]; then
	if [ -z "$DIR_MOD" ]; then
		DIR_MOD=$INSTALL_DIR
	else
		DIR_MOD=$BASE_DIR/$DIR_MOD
	fi

	OK=0
	if [ ! -d "$DIR_MOD" ]; then
		echo -e "[ \e[0;31m$2\e[0m ] Creating directory $DIR_MOD..."
		mkdir $DIR_MOD
		if [ ! -d "$DIR_MOD" ]; then
			OK=1
		fi
	fi
	if [ "$OK" == "0" ]; then
		rm -r ~/serverfiles/$2/
		#echo -e "[ \e[0;32m$2\e[0m ] Removed old folder Successfully!"
		cp -aru $DIR_MOD/steamapps/workshop/content/107410/$MOD/. ~/serverfiles/$2/
		#echo -e "[ \e[0;32m$2\e[0m ] Moved Successfully!"
		cp -au $DIR_MOD/steamapps/workshop/content/107410/$MOD/keys/. ~/serverfiles/keys/
		#echo -e "[ \e[0;32m$2\e[0m ] Server keys added Successfully!"
		convmv --lower -r --replace --notest ~/serverfiles/$2/
		#echo -e "[ \e[0;32m$2\e[0m ] Renamed all the files to lowercase Successfully!"
		ShouldRun=1
    exitcode=$?
    if [ ${exitcode} -ne 0 ]; then
      echo -e "[ \e[0;31m$2\e[0m ] Failed Terribly"
      exit 1
    else
      echo -e "[ \e[0;32m$2\e[0m ] Completed Successfully"
    fi
		#echo "Complete! You moved AppID $MOD into $DIR_MOD successfully."
	#else
		#echo -e "[ \e[0;33m$2\e[0m ] WARNING! Cannot move AppID $MOD into $DIR_MOD. Failed to create directory"
	fi
fi
}
add_move "$DL_MD0" "$DL_NM0"
add_move "$DL_MD1" "$DL_NM1"
add_move "$DL_MD2" "$DL_NM2"
add_move "$DL_MD3" "$DL_NM3"
add_move "$DL_MD4" "$DL_NM4"
add_move "$DL_MD5" "$DL_NM5"
add_move "$DL_MD6" "$DL_NM6"
add_move "$DL_MD7" "$DL_NM7"
add_move "$DL_MD8" "$DL_NM8"
add_move "$DL_MD9" "$DL_NM9"
add_move "$DL_MD10" "$DL_NM10"
add_move "$DL_MD11" "$DL_NM11"
add_move "$DL_MD12" "$DL_NM12"
add_move "$DL_MD13" "$DL_NM13"
add_move "$DL_MD14" "$DL_NM14"
add_move "$DL_MD15" "$DL_NM15"
add_move "$DL_MD16" "$DL_NM16"
add_move "$DL_MD17" "$DL_NM17"
add_move "$DL_MD18" "$DL_NM18"
add_move "$DL_MD19" "$DL_NM19"
add_move "$DL_MD20" "$DL_NM20"
add_move "$DL_MD21" "$DL_NM21"
add_move "$DL_MD22" "$DL_NM22"
add_move "$DL_MD23" "$DL_NM23"
add_move "$DL_MD24" "$DL_NM24"
add_move "$DL_MD25" "$DL_NM25"
add_move "$DL_MD26" "$DL_NM26"
add_move "$DL_MD27" "$DL_NM27"
add_move "$DL_MD28" "$DL_NM28"
add_move "$DL_MD29" "$DL_NM29"

echo ""
#This starts the server after the process has Downloaded and moved all the mods.
./arma3server start

echo ""
echo ""
echo "###################################"
echo "###################################"
echo "###   All mods/server updated   ###"
echo "###    server/mod updater by:   ###"
echo "###         JediNarwals         ###"
echo "###################################"
echo "###################################"
echo ""

exit 0
