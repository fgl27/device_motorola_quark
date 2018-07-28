# Device configuration for Moto MAXX (Quark)

Copyright 2015 to Today - Felipe Leon Project

Copyright 2015 to 2016 - The CyanogenMod Project

Copyright 2017 - 2018 - The LineageOS   Project

**I use this tree to build TWRP in Oreo lineage-15.x base source
**Do not use this tree to build a ROM**
This tree works prefect in ResurrectionRemix Nougat

How to build this...
The below may be out of data check XDA thread to make shore the descrived tree below are the one be used today...
Use the below in /home/user/source/.repo/local_manifests/roomservice.xml

	<?xml version="1.0" encoding="UTF-8"?>
	<manifest>

	  <!-- Common qcom to build dtb and some etc lib-->
	  <project name="LineageOS/android_device_qcom_common" path="device/qcom/common" remote="github" revision="lineage-15.1" />

	  <!-- Device/kernel/vendor-->
	  <project name="bhb27/device_motorola_quark" path="device/motorola/quark" remote="github" revision="TWRP_N" />
	  <project name="bhb27/BHB27Kernel" path="kernel/motorola/apq8084" remote="github" revision="N_c" />

	  <!-- Need to build TWRP-->
	  <project path="external/busybox" name="omnirom/android_external_busybox" remote="github" revision="android-8.1" />
	  <remove-project path="bootable/recovery" name="LineageOS/android_bootable_recovery" groups="pdk" />
	  <project path="bootable/recovery" name="omnirom/android_bootable_recovery" remote="github" revision="android-8.1" groups="pdk-cw-fs"/>

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


![MOTO MAXX](https://raw.githubusercontent.com/bhb27/scripts/f45458e4bc40dcc6d71ed933d49dad01a3b63f4b/etc/images/moto-maxx.jpg "MOTO MAXX")
