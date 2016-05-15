#!/bin/bash
# simple build sh ... alias br='/home/user/source_folder/device/motorola/quark/rootdir/etc/sbin/build.sh'


cd ~/om
. build/envsetup.sh
make clean
mv /home/fella/m/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8 /home/fella/m/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8.g
mv /home/fella/m/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8.1 /home/fella/m/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8
cd ~/m
. build/envsetup.sh 
make clean 
lunch cm_quark-userdebug
time mka bacon -j4 2>&1 | tee quark.txt
mv /home/fella/m/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8 /home/fella/m/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8.1
mv /home/fella/m/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8.g /home/fella/m/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8

