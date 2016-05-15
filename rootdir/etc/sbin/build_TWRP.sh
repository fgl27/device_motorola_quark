#!/bin/bash
# simple build sh ... alias bt='/home/user/source_folder/device/motorola/quark/rootdir/etc/sbin/build_TWRP.sh'


cd ~/om
. build/envsetup.sh 
lunch omni_quark-eng
make clean
time make recoveryimage -j4  2>&1 | tee twrp.txt

