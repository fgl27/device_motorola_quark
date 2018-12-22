# Device configuration for Moto MAXX (Quark)

Copyright 2015 to Today - Felipe Leon Project<br/>
Copyright 2015 to 2016 - The CyanogenMod Project<br/>
Copyright 2017 - 2018 - The LineageOS Project

### This is a WIP P branch

### How to build this...

Pull the below repos creating a file **"/home/user/source_folder/.repo/local_manifests/roomservice.xml"** and pasting the bellow

	<?xml version="1.0" encoding="UTF-8"?>
	<manifest>
	
	  <!-- Strings for LineageActions app-->
	  <project name="LineageOS/android_packages_resources_devicesettings" path="packages/resources/devicesettings" remote="github" revision="lineage-16.0" />

	  <!-- Radio ralated lib-->
	  <project name="LineageOS/android_system_qcom" path="system/qcom" remote="github" revision="lineage-16.0" />
	
	  <!-- Device/kernel/vendor-->
	  <project name="fgl27/device_motorola_quark" path="device/motorola/quark" remote="github" revision="P" />
	  <project name="fgl27/BHB27Kernel" path="kernel/motorola/apq8084" remote="github" revision="P" />
	  <project name="fgl27/proprietary_vendor_motorola" path="vendor/motorola" remote="github" revision="P" />

	</manifest>

If yours source file **"/home/user/source_folder/.repo/manifests/default.xml"** doesn't have the remote github add the below under **<manifest\>** line in previously created file **"/home/user/source_folder/.repo/local_manifests/roomservice.xml"**.

	  <remote  name="github"
	           fetch="https://github.com/" />

### Fix the source to build for Quark

In **hardware/qcom/bt-caf** [revert](https://github.com/LineageOS/android_hardware_qcom_bt/commit/ddaccd2176683b6de272e7d2718557dbe9b9fe1b).<br/>
This commit prevent enabling Bluetooth after disabling it, making necessary to use **wcnss_filter** binary from another device, but a perfect **wcnss_filter** replacement doesn't exist for Quark.

	cd hardware/qcom/bt-caf
	git revert fa98f0564a17ba5a8e1defa17a2fc73bcfd8f3de --no-edit
	cd -

In **hardware/qcom/display-caf/apq8084** do

	cd hardware/qcom/display-caf/apq8084/
	git fetch https://github.com/LineageOS/android_hardware_qcom_display refs/changes/98/233598/1 && git cherry-pick FETCH_HEAD
	git fetch https://github.com/LineageOS/android_hardware_qcom_display refs/changes/00/233600/2 && git cherry-pick FETCH_HEAD
	git fetch https://github.com/LineageOS/android_hardware_qcom_display refs/changes/04/233604/1 && git cherry-pick FETCH_HEAD
	cd -

In **hardware/qcom/media-caf/apq8084** do

	cd hardware/qcom/media-caf/apq8084/
	git fetch https://github.com/LineageOS/android_hardware_qcom_media refs/changes/02/233602/2 && git cherry-pick FETCH_HEAD
	cd -

## Building after repo sync and fixing the source (fixing the source is always necessary to redo after a "repo sync"):

	. build/envsetup.sh 
	make clean

### Lunch the device in LineageOS

	lunch lineage_quark-userdebug

### Lunch the device in ResurrectionRemix

	lunch rr_quark-userdebug

### Start the build

	time mka bacon -j8 2>&1 | tee quark.txt

Were the **first number** after **-j** is the number of cores you wanna use for this task and **2>&1 | tee quark.txt** will export the build "output" to  a file **quark.txt**, read it in case the build fails searching for the reason of the fail.

This link ([Setup_new_build_machine](https://github.com/fgl27/scripts/blob/master/etc/new_machine.md#for-general-android-app-build-machine--adb-shell-and-fastboot-for-debugging)) may help to setup a build machine in case you don't know how to, but that is very personalized for me so carefully read it.

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
