# Device configuration for Moto MAXX (Quark)

Copyright 2015 to Today - Felipe Leon Project :sunglasses:<br/>
Copyright 2015 to 2016 - The CyanogenMod Project<br/>
Copyright 2017 - 2018 - The LineageOS Project

## I use this tree to build Lineage-17.x base sources

This tree must works to build on [LineageOS 17.1](https://github.com/LineageOS/android/tree/lineage-17.1), but in case it doesn't the fixes are usually very simple if you can't fix it **mention** @fgl27 on one of the XDA threads links in [device_motorola_quark/wiki](https://github.com/fgl27/device_motorola_quark/wiki)

### How to build this...

Pull the below repos creating a file **"/home/user/source_folder/.repo/local_manifests/roomservice.xml"** and pasting the bellow

	<?xml version="1.0" encoding="UTF-8"?>
	<manifest>

	  <!-- Radio ralated lib-->
	  <project name="LineageOS/android_system_qcom" path="system/qcom" remote="github" revision="lineage-17.1" />
	
	  <!-- Device/kernel/vendor-->
	  <project name="fgl27/device_motorola_quark" path="device/motorola/quark" remote="github" revision="Q" />
	  <project name="fgl27/BHB27Kernel" path="kernel/motorola/apq8084" remote="github" revision="Q" />
	  <project name="fgl27/proprietary_vendor_motorola" path="vendor/motorola" remote="github" revision="Q" />

	</manifest>

If yours source file **"/home/user/source_folder/.repo/manifests/default.xml"** doesn't have the remote github add the below under **<manifest\>** line in previously created file **"/home/user/source_folder/.repo/local_manifests/roomservice.xml"**.

	  <remote  name="github"
	           fetch="https://github.com/" />

### Fix the source to build for Quark

From source main folder do

### Re-enable wfd

	cd frameworks/av
	git fetch "https://github.com/LineageOS/android_frameworks_av" refs/changes/98/266398/1 && git cherry-pick FETCH_HEAD
	git fetch "https://github.com/LineageOS/android_frameworks_av" refs/changes/99/266399/1 && git cherry-pick FETCH_HEAD
	git fetch "https://github.com/LineageOS/android_frameworks_av" refs/changes/00/266400/1 && git cherry-pick FETCH_HEAD
	git fetch "https://github.com/LineageOS/android_frameworks_av" refs/changes/01/266401/1 && git cherry-pick FETCH_HEAD
	git fetch "https://github.com/LineageOS/android_frameworks_av" refs/changes/02/266402/1 && git cherry-pick FETCH_HEAD
	git fetch "https://github.com/LineageOS/android_frameworks_av" refs/changes/03/266403/1 && git cherry-pick FETCH_HEAD
	git fetch "https://github.com/LineageOS/android_frameworks_av" refs/changes/04/266404/1 && git cherry-pick FETCH_HEAD
	git fetch "https://github.com/LineageOS/android_frameworks_av" refs/changes/05/266405/1 && git cherry-pick FETCH_HEAD
	git fetch "https://github.com/LineageOS/android_frameworks_av" refs/changes/06/266406/1 && git cherry-pick FETCH_HEAD
	cd -

## Building after repo sync and fixing the source (fixing the source is always necessary to redo after a "repo sync"):

	. build/envsetup.sh 
	make clean

### Lunch the device in LineageOS

	lunch lineage_quark-userdebug

### Start the build

	time mka bacon -j8 2>&1 | tee quark.txt

Were the **first number** after **-j** is the number of cores you wanna use for this task and **2>&1 | tee quark.txt** will export the build "output" to a file **quark.txt**, read it in case the build fails searching for the reason of the fail.

This link ([Build for shamu](https://wiki.lineageos.org/devices/shamu/build)) may help to setup a build machine in case you don't know how to, be aware that shamu is a device that is not this use that page as a way to setup the built environment only.

The Motorola Moto Maxx (codenamed _"quark"_) is a high-end smartphone from Motorola mobility.<br/>
It was announced on November 2014.

Basic   | Spec Sheet
-------:|:-------------------------
CPU     | Quad-core 2.7 GHz Krait 450
Chipset | Qualcomm Snapdragon 805
GPU     | Adreno 420
Memory  | 3GB RAM
Shipped Android Version | 4.4.4
Storage | 64 GB
MicroSD | No
Battery | Non-removable Li-Po 3900 mAh battery
Display | 1440 x 2560 pixels, 5.2 inches (~565 ppi pixel density)
Camera  | 21 MP (5248 x 3936), auto focus, dual-LED flash


![MOTO MAXX](https://raw.githubusercontent.com/fgl27/scripts/f45458e4bc40dcc6d71ed933d49dad01a3b63f4b/etc/images/moto-maxx.jpg "MOTO MAXX")
