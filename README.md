# Device configuration for Moto MAXX (Quark)

Copyright 2015 to Today - Felipe Leon Project<br/>
Copyright 2015 to 2016 - The CyanogenMod Project<br/>
Copyright 2017 - 2018 - The LineageOS Project

## I use this tree to build in Oreo lineage-15.x base source

This tree works prefect in [LineageOS 15.1](https://github.com/LineageOS/android/tree/lineage-15.1)
 and [ResurrectionRemix Oreo](https://github.com/ResurrectionRemix/platform_manifest/tree/oreo) sources

### How to build this...

Pull the below repos creating a file **"/home/user/source_folder/.repo/local_manifests/roomservice.xml"** and pasting the bellow

	<?xml version="1.0" encoding="UTF-8"?>
	<manifest>
	
	  <!-- Strings for LineageActions app-->
	  <project name="LineageOS/android_packages_resources_devicesettings" path="packages/resources/devicesettings" remote="github" revision="lineage-15.1" />
	
	  <!-- Device/kernel/vendor-->
	  <project name="fgl27/device_motorola_quark" path="device/motorola/quark" remote="github" revision="O" />
	  <project name="fgl27/BHB27Kernel" path="kernel/motorola/apq8084" remote="github" revision="O" />
	  <project name="fgl27/proprietary_vendor_motorola" path="vendor/motorola" remote="github" revision="O" />

	</manifest>

If yours source file **"/home/user/source_folder/.repo/manifests/default.xml"** doesn't have the remote github add the below under **<manifest\>** line in previously created file **"/home/user/source_folder/.repo/local_manifests/roomservice.xml"**.

	  <remote  name="github"
	           fetch="https://github.com/" />

### Fix the source to build for Quark

In **hardware/qcom/bt-caf** [revert](https://github.com/LineageOS/android_hardware_qcom_bt/commit/ddaccd2176683b6de272e7d2718557dbe9b9fe1b).<br/>
This commit prevent enabling Bluetooth after disabling it, making necessary to use **wcnss_filter** binary from another device, but a perfect **wcnss_filter** replacement doesn't exist for Quark.

	cd hardware/qcom/bt-caf
	git revert ddaccd2176683b6de272e7d2718557dbe9b9fe1b --no-edit
	cd -

In **system/extras/su** (Not demanding) revert [1](https://github.com/LineageOS/android_system_extras_su/commit/bffcdefa59834186b75987541930dbfa92d15a21) and [2](https://github.com/LineageOS/android_system_extras_su/commit/ae77c1a8aa19484d8d8196e55254f2c6f01d1aad).<br/>
This commit's prevent enabling SU by default using just a prop

	cd system/extras/su
	git revert bffcdefa59834186b75987541930dbfa92d15a21 --no-edit
	git revert ae77c1a8aa19484d8d8196e55254f2c6f01d1aad --no-edit
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
