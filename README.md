# Device configuration for Moto MAXX (Quark)

Copyright 2015 to Today - Felipe Leon Project

Copyright 2015 to 2016 - The CyanogenMod Project

Copyright 2017 - 2018 - The LineageOS   Project

## I use this tree to build in Oreo lineage-15.x base source

This tree works prefect in LineageOS or ResurrectionRemix Oreo source

How to build this...
The below may be out of data check XDA thread to make shore the described tree (Device/kernel/vendor) below are the one be used today...
Use the below in /home/user/source/.repo/local_manifests/roomservice.xml

	<?xml version="1.0" encoding="UTF-8"?>
	<manifest>
	
	  <!-- Common qcom to build dtb and some etc lib-->
	  <project name="LineageOS/android_device_qcom_common" path="device/qcom/common" remote="github" revision="lineage-15.1" />
	
	  <!-- Strings for LineageActions strings-->
	  <project name="LineageOS/android_packages_resources_devicesettings" path="packages/resources/devicesettings" remote="github" revision="lineage-15.1" />
	
	  <!-- Device/kernel/vendor-->
	  <project name="bhb27/device_motorola_quark" path="device/motorola/quark" remote="github" revision="O" />
	  <project name="bhb27/BHB27Kernel" path="kernel/motorola/apq8084" remote="github" revision="O" />
	  <project name="bhb27/proprietary_vendor_motorola" path="vendor/motorola" remote="github" revision="O" />

	</manifest>

### Fix the source to build for Quark

In **device/qcom/sepolicy** cherry-pick

https://github.com/bhb27/android_device_qcom_sepolicy/commit/c548bf97b5fbe58ea8389ce82e97d9d9f20c48c3

In **system/extras/su** (Only needed in RR) revert

ae77c1a8aa19484d8d8196e55254f2c6f01d1aad

## Building after repo sync and fix the source (fix the source after repo sync):

	. build/envsetup.sh 
	make clean

### Lunch the device in LineageOS

	lunch lineage_quark-userdebug

### Lunch the device in ResurrectionRemix

	lunch rr_quark-userdebug

### Start the build

	time mka bacon -j8 2>&1 | tee quark.txt

Were the **number** after **-j** is the number of cores you wanna use for this task, **quark.txt** contains the build "output", read it in case the build fails searching for errors

This link ([New_build_machine](https://github.com/bhb27/scripts/blob/master/etc/new_machine.md#apt-get-install-start)) may help to setup a build machine in case you don't know how to.

The Motorola Moto Maxx (codenamed _"quark"_) is a high-end smartphone from Motorola mobility.
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
Camera  | 21 MP (5248 x 3936), autofocus, dual-LED flash


![MOTO MAXX](https://raw.githubusercontent.com/bhb27/scripts/f45458e4bc40dcc6d71ed933d49dad01a3b63f4b/etc/images/moto-maxx.jpg "MOTO MAXX")
