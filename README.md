# Device configuration for Moto MAXX (Quark)

Copyright 2015 to Today - Felipe Leon Project<br/>
Copyright 2015 to 2016 - The CyanogenMod Project<br/>
Copyright 2017 - 2018 - The LineageOS Project

**I use this tree to build TWRP in Oreo lineage-15.x base source**<br/>
**Do not use this tree to build a ROM**

How to build this...

Pull the below repos creating a file **"/home/user/source_folder/.repo/local_manifests/roomservice.xml"** and pasting the bellow

	<?xml version="1.0" encoding="UTF-8"?>
	<manifest>

	  <!-- Device/kernel/vendor-->
	  <project name="fgl27/device_motorola_quark" path="device/motorola/quark" remote="github" revision="P_TWRP" />
	  <project name="fgl27/BHB27Kernel" path="kernel/motorola/apq8084" remote="github" revision="Q_c" />

	  <!-- omnirom TWRP repos-->
	  <remove-project path="bootable/recovery" name="LineageOS/android_bootable_recovery" groups="pdk" />
	  <project path="bootable/recovery" name="TeamWin/android_bootable_recovery" remote="github" revision="android-9.0" groups="pdk-cw-fs"/>

	  <!-- motorola f2fs repo needed to support -r (reserved_bytes ) option of f2fs
	  https://github.com/MotorolaMobilityLLC/motorola-external-f2fs-tools/commit/1eab4d420c95c795de76ce4c839b54c701aa33c3 -->
	  <remove-project path="external/f2fs-tools" name="LineageOS/android_external_f2fs-tools" groups="pdk" />
	  <project name="MotorolaMobilityLLC/motorola-external-f2fs-tools" path="external/f2fs-tools" remote="github" revision="pie-9.0.0-release" />

	</manifest>

If yours source file **"/home/user/source_folder/.repo/manifests/default.xml"** doesn't have the remote github add the below under **<manifest\>** line in previously created file **"/home/user/source_folder/.repo/local_manifests/roomservice.xml"**.

	  <remote  name="github"
	           fetch="https://github.com/" />

Them after repo it all use this to build

	. build/envsetup.sh
	lunch lineage_quark-eng
	make clean
	time make recoveryimage -j4  2>&1 | tee twrp.txt

Were the **first number** after **-j** is the number of cores you wanna use for this task and **2>&1 | tee twrp.txt** will export the build "output" to  a file **quark.txt**, read it in case the build fails searching for the reason of the fail.

This link ([New_build_machine](https://github.com/fgl27/scripts/blob/master/etc/new_machine.md#apt-get-install-start)) may help to setup a build machine in case you don't know how to, but that is very personalized for me so carefully read it.

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
