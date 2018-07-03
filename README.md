# Device configuration for Moto MAXX (Quark)

Copyright 2016 to today - Felipe Leon Project

Copyright 2016 - The CyanogenMod Project

Copyright 2017 - 2018 - The LineageOS   Project

## I use this tree to build in Oreo lineage-15.x base source

This tree works prefect in LineageOS or ResurrectionRemix Oreo soruces

How to build this...
The below may be out of data check XDA thread to make shore the described tree (Device/kernel/vendor) below are the one be used today...
Use the below in /home/user/source/.repo/local_manifests/roomservice.xml

	<?xml version="1.0" encoding="UTF-8"?>
	<manifest>

	  <!-- Common qcom to build dtb and some etc lib-->
	  <project name="LineageOS/android_device_qcom_common" path="device/qcom/common" remote="github" revision="lineage-15.1" />
	  <!-- Strings for CMActions-->
	  <project name="LineageOS/android_packages_resources_devicesettings" path="packages/resources/devicesettings" remote="github" revision="lineage-15.1" />
	  <!-- Device/kernel/vendor-->
	  <project name="bhb27/device_motorola_quark" path="device/motorola/quark" remote="github" revision="O" />
	  <project name="bhb27/BHB27Kernel" path="kernel/motorola/apq8084" remote="github" revision="O" />
	  <project name="bhb27/proprietary_vendor_motorola" path="vendor/motorola" remote="github" revision="O" />

	</manifest>

### Fix the source to build for Quark

In **frameworks/native/** cherry-pick

https://github.com/bhb27/frameworks_native/commit/01df205b39e2465a36deaf11f76f8a63da414c3d

In **system/sepolicy/** do

git fetch https://github.com/LineageOS/android_system_sepolicy refs/changes/47/205947/1 && git cherry-pick FETCH_HEAD

In **system/core/** cherry-pick

https://github.com/bhb27/system_core/commit/2ae38319deb341f5a87c60f19ed7efca19e9c103

In **system/qcom/** cherry-pick

https://github.com/bhb27/android_system_qcom/commit/6b839a2decf5cce326d0933d0402ad5fb86e526f

In **hardware/qcom/bt-caf** revert

https://github.com/LineageOS/android_hardware_qcom_bt/commit/ddaccd2176683b6de272e7d2718557dbe9b9fe1b
https://github.com/LineageOS/android_hardware_qcom_bt/commit/90fd648335032144de1900fcda33c96458eb2606

## Building after sync and fix the source:

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
