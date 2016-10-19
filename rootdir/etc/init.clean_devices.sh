#!/system/bin/sh

if [ -e /data/tmp ]; then
	echo "init clean on $(date)" > /data/tmp/bootcheck.txt;
else
mkdir /data/tmp;
fi;

fsgid=`getprop ro.boot.fsg-id`;
device=`getprop ro.boot.hardware.sku`

## Clean Verizon blobs on others devices
if  [ "$device" == XT1225 ] ||  [ "$fsgid" == emea ] || [ "$fsgid" == singlela ]; then

	mount -o rw,remount /system
	# delete main folders
	app="system/app";
	bin="system/bin";
	etc="system/etc/permissions";
	frameworks="system/frameworks";
	lib="system/lib";
	priv_app="system/priv-app";
	vendor_lib="system/vendor/lib";

	for FILE in $app/ims $app/VZWAPNLib $priv_app/AppDirectedSMSProxy $priv_app/BuaContactAdapter $priv_app/VZWAPNService  $bin/imsdatadaemon $bin/imsqmidaemon $etc/com.verizon.hardware.telephony.ehrpd.xml $etc/com.verizon.hardware.telephony.lte.xml $etc/com.verizon.ims.xml  $etc/rcsservice.xml $etc/rcsimssettings.xml $etc/com.motorola.DirectedSMSProxy.xml $etc/com.vzw.vzwapnlib.xml $frameworks/com.verizon.hardware.telephony.ehrpd.jar $frameworks/com.verizon.hardware.telephony.lte.jar $frameworks/com.verizon.ims.jar $frameworks/rcsimssettings.jar $frameworks/rcsservice.jar $lib/libimscamera_jni.so $lib/libimsmedia_jni.so $vendor_lib/lib-dplmedia.so $vendor_lib/lib-ims-setting-jni.so $vendor_lib/lib-ims-settings.so $vendor_lib/lib-imsSDP.so $vendor_lib/lib-imsdpl.so $vendor_lib/lib-imsqimf.so $vendor_lib/lib-imsrcs.so $vendor_lib/lib-imss.so $vendor_lib/lib-imsvt.so $vendor_lib/lib-imsxml.so $vendor_lib/lib-rcsimssjni.so $vendor_lib/lib-rcsjni.so $vendor_lib/lib-rtpcommon.so $vendor_lib/lib-rtpcore.so $vendor_lib/lib-rtpdaemoninterface.so $vendor_lib/lib-rtpsl.so $vendor_lib/libvcel.so; do

		if [ -e "$FILE" ]; then 
			rm -rf $FILE;
		fi;

	done

	umount /system;
	echo "init.clean_devices file deleted for device = $device fsgid = $fsgid" >> /data/tmp/bootcheck.txt;
else
	echo "init.clean_devices bn file deleted for device = $device fsgid = $fsgid" >> /data/tmp/bootcheck.txt;
fi;

