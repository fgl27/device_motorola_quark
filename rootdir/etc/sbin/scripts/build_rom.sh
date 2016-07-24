#!/bin/bash
# simple build sh ... alias br='/home/user/source_folder/device/motorola/quark/rootdir/etc/sbin/build.sh'

#timer counter
START=$(date +%s.%N);
START2="$(date)";
echo -e "\n build start $(date)\n";


#source tree folder yours machine source folder
#main source foludes
#FOLDER=/home/bhb27/android/om;
#other source folder on the same machine, because of cacche gcc tool is connected
FOLDER2=/home/bhb27/android/m;

#cd ~/om
#. build/envsetup.sh
#make clean

#mv toolchain as I use none stock one, move on RR and Omni source because my cacche 
#mv $FOLDER2/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8 $FOLDER2/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8.g
#mv $FOLDER2/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8.1 $FOLDER2/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8
#mv $FOLDER/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8 $FOLDER/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8.g
#mv $FOLDER/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8.1 $FOLDER/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8

cd $FOLDER2
. build/envsetup.sh 
make clean 
lunch cm_quark-userdebug
time mka bacon -j4 2>&1 | tee quark.txt

#mv toolchain back
#mv $FOLDER2/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8 $FOLDER2/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8.1
#mv $FOLDER2/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8.g $FOLDER2/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8
#mv $FOLDER/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8 $FOLDER/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8.1
#mv $FOLDER/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8.g $FOLDER/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8

# final time display *cosmetic...
END2="$(date)";
END=$(date +%s.%N);
echo -e "\nBuild start $START2";
echo -e "Build end   $END2 \n";
echo -e "\n${bldgrn}Total time elapsed: ${txtrst}${grn}$(echo "($END - $START) / 60"|bc ):$(echo "(($END - $START) - (($END - $START) / 60) * 60)"|bc ) (minutes:seconds). ${txtrst}\n";

