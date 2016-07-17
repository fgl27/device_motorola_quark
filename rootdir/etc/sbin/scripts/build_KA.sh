#!/bin/bash
# simple build sh to build a apk check folder and sign ...set on yours .bashrc to call this sh from anywhere alias bt='/home/user/this.sh'

#timer counter
START=$(date +%s.%N);
START2="$(date)";
echo -e "\n Script start $(date)\n";

#Folders Folder= you app folder SDK_Folder android sdk folder Download it if you don't have it, don't remove the sdk.dir= from the line

FOLDER=/home/fella/KA27;
SDK_FOLDER="sdk.dir=/home/fella/sdk";

# Export Java path in some machines is necessary put your java path

export JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64/"

# Auto sign apk Download from my folder link below extract and set the folder below on yours machine
# https://www.androidfilehost.com/?fid=24588232905720654

SIGN=1;
SIGN_FOLDER=/home/fella/ZipScriptSign;

# out app folder and out app name

OUT_FOLDER=$FOLDER/app/build/outputs/apk;
APP_FINAL_NAME=KernelAdiutor.apk;

# make zip only used if you have the need to make a zip of this a flash zip template is need
# ZIPFOLDER = folder of the zip the contains the flash zip template, 
# ZIPAPPFOLDER = folder of the zip the contains the apk inside the zip
MKZIP=1;
ZIPFOLDER=$FOLDER/zip/;
ZIPAPPFOLDER=$ZIPFOLDER/system/priv-app/KernelAdiutor;
ZIPNAME=kernelauditor-update-0.9.9.4.+14.BHB27-Mod;

#making start here...

cd $FOLDER;

if [ ! -e ./local.properties ]; then
	echo -e "$\n local.properties not found...\nMaking a local.properties files using script information\n
\n local.properties done starting the build";
	touch $FOLDER.local.properties;
	echo $SDK_FOLDER > local.properties;
fi;
localproperties=`cat local.properties`;
if [ $localproperties != $SDK_FOLDER ]; then
	echo -e "\nSDK folder set as \n$SDK_FOLDER in the script \nbut local.properties file content is\n$localproperties\nfix it using script value";
	rm -rf .local.properties;
	touch $FOLDER.local.properties;
	echo $SDK_FOLDER > local.properties;
fi;

./gradlew clean
echo -e "\n The above is just the cleaning build start now\n";
./gradlew build

if [ $SIGN == 1 ]; then
if [ ! -e ./app/build/outputs/apk/app-release-unsigned.apk ]; then
	echo -e "\n${bldred}App not build${txtrst}\n"
	exit 1;
else
	echo -e "\n${bldred}Signing the App${txtrst}\n"
	$SIGN_FOLDER/sign.sh test $OUT_FOLDER/app-release-unsigned.apk
	mv $OUT_FOLDER/app-release-unsigned.apk-signed.zip $OUT_FOLDER/$APP_FINAL_NAME
fi;
fi;

if [ $MKZIP == 1 ]; then
	echo -e "\n${bldred}Making a zip${txtrst}\n"
	cp -rf $OUT_FOLDER/$APP_FINAL_NAME $ZIPAPPFOLDER/$APP_FINAL_NAME
	cd $ZIPFOLDER/
	rm -rf *.zip
	zip -r9 $ZIPNAME * -x *.gitignore
	echo -e "\n${bldred}Signing the zip${txtrst}\n"
	$SIGN_FOLDER/sign.sh test $ZIPFOLDER/$ZIPNAME
	rm -rf $ZIPFOLDER/$ZIPNAME
	mv $ZIPFOLDER/$ZIPNAME-signed.zip $ZIPFOLDER/$ZIPNAME.zip
fi;

END2="$(date)";
END=$(date +%s.%N);
echo -e "\nScript start $START2";
echo -e "End $END2 \n";
echo -e "\n${bldgrn}Total time elapsed of the script: ${txtrst}${grn}$(echo "($END - $START) / 60"|bc ):$(echo "(($END - $START) - (($END - $START) / 60) * 60)"|bc ) (minutes:seconds). ${txtrst}\n";

