# Device configuration for Moto MAXX (Quark)

Copyright 2015 to Today - Felipe Leon Project<br/>
Copyright 2015 to 2016 - The CyanogenMod Project<br/>
Copyright 2017 - 2018 - The LineageOS   Project

## I use this tree to build in Oreo lineage-15.x base source

This tree works prefect in [LineageOS 15.1](https://github.com/LineageOS/android/tree/lineage-15.1)
 and [ResurrectionRemix Oreo](https://github.com/ResurrectionRemix/platform_manifest/tree/oreo) sources

### How to build this...

Pull the below repos using **"/home/user/source/.repo/local_manifests/roomservice.xml"**

	<?xml version="1.0" encoding="UTF-8"?>
	<manifest>
	
	  <!-- Strings for LineageActions app-->
	  <project name="LineageOS/android_packages_resources_devicesettings" path="packages/resources/devicesettings" remote="github" revision="lineage-15.1" />
	
	  <!-- Device/kernel/vendor-->
	  <project name="fgl27/device_motorola_quark" path="device/motorola/quark" remote="github" revision="O" />
	  <project name="fgl27/fgl27Kernel" path="kernel/motorola/apq8084" remote="github" revision="O" />
	  <project name="fgl27/proprietary_vendor_motorola" path="vendor/motorola" remote="github" revision="O" />

	</manifest>

If yours source **"/home/user/source/.repo/manifests/default.xml"** doesn't have the remote github add the below under **<manifest\>** line in **"/home/user/source/.repo/local_manifests/roomservice.xml"** file.

	  <remote  name="github"
	           fetch="https://github.com/" />

### Fix the source to build for Quark

In **hardware/qcom/bt-caf** [revert](https://github.com/LineageOS/android_hardware_qcom_bt/commit/ddaccd2176683b6de272e7d2718557dbe9b9fe1b).<br/>
This commit prevent enabling Bluetooth after disabling it, making necessary to use **wcnss_filter** binary from another device, but not perfect **wcnss_filter** replacement exist.

	cd hardware/qcom/bt-caf
	git revert ddaccd2176683b6de272e7d2718557dbe9b9fe1b
	cd -

In **system/extras/su** (Not demanding) [revert](https://github.com/LineageOS/android_system_extras_su/commit/ae77c1a8aa19484d8d8196e55254f2c6f01d1aad).<br/>
This commit prevent enabling SU by default using just a prop

	cd system/extras/su
	git revert ddaccd2176683b6de272e7d2718557dbe9b9fe1b
	cd -

## Building after repo sync and fix the source (fix the source always after repo sync):

	. build/envsetup.sh 
	make clean

### Lunch the device in LineageOS

	lunch lineage_quark-userdebug

### Lunch the device in ResurrectionRemix

	lunch rr_quark-userdebug

### Start the build

	time mka bacon -j8 2>&1 | tee quark.txt

Were the **number** after **-j** is the number of cores you wanna use for this task, **quark.txt** contains the build "output", read it in case the build fails searching for errors

This link ([New_build_machine](https://github.com/fgl27/scripts/blob/master/etc/new_machine.md#apt-get-install-start)) may help to setup a build machine in case you don't know how to.

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
