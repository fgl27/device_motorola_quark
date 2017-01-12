Device configuration for Moto MAXX (Quark)
==============================
Copyright 2016 - The CyanogenMod Project
Copyright 2017 - The LineageOS   Project

**I use this tree to build TWRP in Nougat cm-14.x and cm-14.x base source**
**Do not use this to build a ROM**
This tree works prefect in ResurrectionRemix Nougat, may need some minor cosmetic Strings changes in **cm.mk**  BUILD_DISPLAY_ID

How to build this...
The below may be out of data check XDA thread to make shore the descrived tree below are the one be used today...
Use the below in /home/user/source/.repo/local_manifests/roomservice.xml

	<?xml version="1.0" encoding="UTF-8"?>
	<manifest>

	  <!-- Common qcom to build dtb and some etc lib-->
	  <project name="LineageOS/android_device_qcom_common" path="device/qcom/common" remote="github" revision="cm-14.1" />
	  <!-- Strings for CMActions-->
	  <project name="LineageOS/android_packages_resources_devicesettings" path="packages/resources/devicesettings" remote="github" revision="cm-14.1" />
	  <!-- Device/kernel/vendor-->
	  <project name="bhb27/device_motorola_quark" path="device/motorola/quark" remote="github" revision="TWRP_7.1" />
	  <project name="bhb27/BHB27Kernel" path="kernel/motorola/apq8084" remote="github" revision="NEW_TWRP_7.1" />

	  <!-- Need to build TWRP-->
	  <project path="external/busybox" name="omnirom/android_external_busybox" remote="github" revision="android-7.1" />
	  <remove-project path="bootable/recovery" name="LineageOS/android_bootable_recovery" groups="pdk" />
	  <project path="bootable/recovery" name="omnirom/android_bootable_recovery" remote="github" revision="android-7.1" groups="pdk-cw-fs"/>

	  <!-- Some CM project are out of date I update they here-->
	  <remove-project name="LineageOS/android_hardware_qcom_display" groups="pdk,qcom,qcom_display" revision="cm-14.1-caf-8084" />
	  <project path="hardware/qcom/display-caf/apq8084" name="bhb27/android_hardware_qcom_display" remote="github" revision="cm-14.1-caf-8084" />
	  <remove-project name="LineageOS/android_hardware_qcom_media" groups="pdk,qcom,qcom_media" revision="cm-14.1-caf-8084" />
	  <project path="hardware/qcom/media-caf/apq8084" name="bhb27/android_hardware_qcom_media" remote="github" revision="cm-14.1-caf-8084" />
	  <remove-project path="device/qcom/sepolicy" name="LineageOS/android_device_qcom_sepolicy" />
	  <project path="device/qcom/sepolicy" name="bhb27/android_device_qcom_sepolicy" remote="github" revision="cm-14.1" />

	</manifest>

Them after repo it all use this to build

	. build/envsetup.sh
	make clean
	lunch cm_quark-eng
	time make recoveryimage -j4  2>&1 | tee twrp.txt

were -j4 is the number of thread avalible, and **twrp.txt** is a log file to check for build errors

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


![MAXX](https://dl.dropboxusercontent.com/u/281742759/maxx/novo-moto-maxx-1.jpg "MAXX")
