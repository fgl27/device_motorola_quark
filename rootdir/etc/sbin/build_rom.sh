#!/bin/bash
# simple build sh ... alias br='/home/user/source_folder/device/motorola/quark/rootdir/etc/sbin/build.sh'


cd ~/m
. build/envsetup.sh 
make clean 
lunch cm_quark-userdebug
time mka bacon -j4 2>&1 | tee quark.txt


