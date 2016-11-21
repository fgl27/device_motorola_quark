Device configuration for Moto MAXX (Quark)
==============================
Copyright 2016 - The CyanogenMod Project

**I use this tree to build in Nougat cm-14.x and cm-14.x base source**
This tree works prefect in crDroid Nougat, may need some minor cosmetic Strings changes in **cm.mk**  BUILD_DISPLAY_ID and in **cmactions/src/com/cyanogenmod/settings/device/TouchscreenGesturePreferenceFragment.java** crdroid_settings

How to build this...
The below may be out of data check XDA thread to make shore the descrived tree below are the one be used today...
Use the below in /home/user/source/.repo/local_manifests/roomservice.xml

	<?xml version="1.0" encoding="UTF-8"?>
	<manifest>

	  <!-- Common qcom to build dtb and some etc lib-->
	  <project name="CyanogenMod/android_device_qcom_common" path="device/qcom/common" remote="github" revision="cm-14.1" />

	  <!-- Device/kernel/vendor-->
	  <project name="bhb27/device_motorola_quark" path="device/motorola/quark" remote="github" revision="CR-N" />
	  <project name="bhb27/BHB27Kernel" path="kernel/motorola/apq8084" remote="github" revision="CR-N" />
	  <project name="bhb27/proprietary_vendor_motorola" path="vendor/motorola" remote="github" revision="CR-N" />

	  <!-- Some CM project are out of date I update they here-->
	  <remove-project name="CyanogenMod/android_hardware_qcom_display" groups="pdk,qcom,qcom_display" revision="cm-14.1-caf-8084" />
	  <project path="hardware/qcom/display-caf/apq8084" name="bhb27/android_hardware_qcom_display" remote="github" revision="cm-14.1-caf-8084" />
	  <remove-project name="CyanogenMod/android_hardware_qcom_media" groups="pdk,qcom,qcom_media" revision="cm-14.1-caf-8084" />
	  <project path="hardware/qcom/media-caf/apq8084" name="bhb27/android_hardware_qcom_media" remote="github" revision="cm-14.1-caf-8084" />

	</manifest>

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
