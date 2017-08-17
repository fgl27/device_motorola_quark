Device configuration for Moto MAXX (Quark)
==============================
Copyright 2016 - The CyanogenMod Project

Copyright 2017 - The LineageOS   Project

**I use this tree to build TWRP in Nougat cm-14.x and cm-14.x base source**
**Do not use this tree to build a ROM**
This tree works prefect in ResurrectionRemix Nougat

How to build this...
The below may be out of data check XDA thread to make shore the descrived tree below are the one be used today...
Use the below in /home/user/source/.repo/local_manifests/roomservice.xml

	<?xml version="1.0" encoding="UTF-8"?>
	<manifest>

	  <!-- Common qcom to build dtb and some etc lib-->
	  <project name="LineageOS/android_device_qcom_common" path="device/qcom/common" remote="github" revision="cm-14.1" />

	  <!-- Device/kernel/vendor-->
	  <project name="bhb27/device_motorola_quark" path="device/motorola/quark" remote="github" revision="TWRP_N" />
	  <project name="bhb27/BHB27Kernel" path="kernel/motorola/apq8084" remote="github" revision="N_c" />

	  <!-- Need to build MULTI_ROM_TWRP-->
	  <project path="external/busybox" name="omnirom/android_external_busybox" remote="github" revision="android-7.1" />
	  <remove-project path="bootable/recovery" name="LineageOS/android_bootable_recovery" groups="pdk" />
	  <project path="bootable/recovery" name="bhb27/android_bootable_recovery" remote="github" revision="android-7.1-mrom" groups="pdk-cw-fs"/>
	  <project name="nkk71/libbootimg" path="system/extras/libbootimg" remote="github" revision="master" />
	  <project name="nkk71/multirom" path="system/extras/multirom" remote="github" revision="master" />
	  <project name="multirom-leeco/multirom_adbd" path="system/extras/multirom/adbd" remote="github" revision="master" />
	  <project name="bhb27/kexec-tools" path="system/extras/multirom/kexec-tools" remote="github" revision="master" />

	  <!-- Use stock google toolchain if the below doesn't work-->
	  <remote name = "bitbucket"
		   fetch = "https://bitbucket.org/" />
	  <project path="prebuilts/gcc/linux-x86/arm/uber_arm-eabi-4.9" name="matthewdalex/arm-eabi-4.9" remote="bitbucket" revision="master" clone-depth="1" />
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
