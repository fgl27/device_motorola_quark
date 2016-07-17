#!/bin/bash
# simple build sh ... alias br='/home/user/source_folder/device/motorola/quark/rootdir/etc/sbin/build.sh'

# kernel folder:
FOLDER=/home/fella/apq8084
cd $FOLDER

echo -e "\nAvailable branch to build: \n"
ls .git/refs/remotes/origin/ | grep -v 'HEAD'

echo -e "\nChoose the branch to build: "
read input_variable
echo -e "You choose: $input_variable"

git checkout $input_variable

echo -e "\n"

./build/how_to_build_this.sh

