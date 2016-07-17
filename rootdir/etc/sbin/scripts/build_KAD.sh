#!/bin/bash
# simple build sh to build a apk check folder and sign ...set on yours .bashrc to call this sh from anywere alias bt='/home/user/this.sh'

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



#making start here...

cd $FOLDER;

if [ ! -e ./local.properties ]; then
	echo -e "$\n local.properties not found...\nMaking a local.properties files using script information\n
\n local.properties done starting the build";
	touch $FOLDER.local.properties;
	echo $SDK_FOLDER > local.properties;
fi;
localpropertie=`cat local.properties`;
if [ $localpropertie != $SDK_FOLDER ]; then
	echo -e "\nSDK folder set as \n$SDK_FOLDER in the script \nbut local.properties file content is\n $localpropertie\n fix it using script value";
	rm -rf .local.properties;
	touch $FOLDER.local.properties;
	echo $SDK_FOLDER > local.properties;
fi;

echo -e "\n This script version does't clean before build \n";
./gradlew build

if [ $SIGN == 1 ]; then
if [ ! -e ./app/build/outputs/apk/app-release-unsigned.apk ]; then
	echo -e "$\n{bldred}App not build${txtrst}\n"
	exit 1;
else
	$SIGN_FOLDER/sign.sh test $OUT_FOLDER/app-release-unsigned.apk
	mv $OUT_FOLDER/app-release-unsigned.apk-signed.zip $OUT_FOLDER/$APP_FINAL_NAME
fi;
fi;

END2="$(date)";
END=$(date +%s.%N);
echo -e "\nScript start $START2";
echo -e "End $END2 \n";
echo -e "\n${bldgrn}Total time elapsed of the script: ${txtrst}${grn}$(echo "($END - $START) / 60"|bc ):$(echo "(($END - $START) - (($END - $START) / 60) * 60)"|bc ) (minutes:seconds). ${txtrst}\n";
