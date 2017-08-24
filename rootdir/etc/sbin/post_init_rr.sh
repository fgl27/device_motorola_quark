#!/system/bin/sh

mount -o rw,remount /system

contains() {
    string="$1"
    substring="$2"
    if test "${string#*$substring}" != "$string"
    then
        return 0    # $substring is in $string
    else
        return 1    # $substring is not in $string
    fi
}

#dirty flash checker
romVersion=`getprop ro.modversion`' '`getprop ro.build.user`;
if [ ! -e /data/temprom/ ]; then
	mkdir /data/temprom/;
	echo "$romVersion" > /data/temprom/buildTemp;
fi
buildTemp=`cat /data/temprom/buildTemp`;
if [ "$romVersion" == "$buildTemp" ]; then
	setprop rom.modversionuser clean;
else
	sed -i "s/$romVersion//g" /data/temprom/buildTemp
	sed 's/ *$//' /data/temprom/buildTemp;
	buildTemp=`cat /data/temprom/buildTemp`;
	echo "$buildTemp $romVersion" > /data/temprom/buildTemp;
	echo "$buildTemp" > /dev/kmsg;
	setprop rom.modversionuser dirty;
fi
#dirty flash checker - END

# Adaway only present in some ROM this need to be 755 to execute it libs...
if [ -e /system/app/Adaway/lib/arm/libblank_webserver_exec.so ]; then
	chmod 755 /system/app/Adaway/lib/arm/libblank_webserver_exec.so
fi

if [ -e /system/app/Adaway/lib/arm/libtcpdump_exec.so ]; then
	chmod 755 /system/app/Adaway/lib/arm/libtcpdump_exec.so
fi

# give su root:root to adb su work need for CM-SU
if [ -e /system/xbin/su ]; then
	chown root:root /system/xbin/su
fi

# Init clean start
fsgid=`getprop ro.boot.fsg-id`
device=`getprop ro.boot.hardware.sku`
radio=`getprop ro.boot.radio`
cid=`getprop ro.boot.cid`
clean=0

if  [ "$device" == XT1225 ] || [ "$fsgid" == emea ] || [ "$fsgid" == singlela ]; then
	clean=1
elif  [ "$radio" == 0x5 ] && [ "$cid" == 0xC ]; then
	clean=1
fi

## Clean Verizon blobs on others devices
if [ "$clean" == 1 ]; then

mount -o rw,remount /system

	# stop IMS services Not need for others then VZW users * have disable volte.rc when they are enable remove the #
#	stop imsqmidaemon;
#	stop imsdatadaemon;
#	setprop net.lte.volte_call_capable false

	# delete main folders
	app="/system/app";
	bin="/system/bin";
	etc="/system/etc/permissions";
	framework="/system/framework";
	lib="/system/lib";
	priv_app="/system/priv-app";
	vendor_lib="/system/vendor/lib";

	# delete vzw only files
	for FILE in $app/ims $app/RCSBootstraputil $app/RcsImsBootstraputil $app/VZWAPNLib $priv_app/AppDirectedSMSProxy $priv_app/BuaContactAdapter $priv_app/VZWAPNService $bin/imsdatadaemon $bin/ims_rtp_daemon $bin/imsqmidaemon $etc/com.verizon.hardware.telephony.ehrpd.xml $etc/com.verizon.hardware.telephony.lte.xml $etc/com.verizon.ims.xml  $etc/rcsservice.xml $etc/rcsimssettings.xml $etc/com.motorola.DirectedSMSProxy.xml $etc/com.vzw.vzwapnlib.xml $framework/com.motorola.ims.rcsmanager.jar $framework/com.verizon.hardware.telephony.ehrpd.jar $framework/com.verizon.hardware.telephony.lte.jar $framework/com.verizon.hardware.telephony.srlte.jar $framework/com.verizon.ims.jar $framework/rcsimssettings.jar $framework/rcsservice.jar $lib/libimscamera_jni.so $lib/libimsmedia_jni.so $vendor_lib/lib-dplmedia.so $vendor_lib/lib-ims-setting-jni.so $vendor_lib/lib-ims-settings.so $vendor_lib/lib-imsSDP.so $vendor_lib/lib-imsdpl.so $vendor_lib/lib-imsqimf.so $vendor_lib/lib-imsrcs.so $vendor_lib/lib-imss.so $vendor_lib/lib-imsvt.so $vendor_lib/lib-imsxml.so $vendor_lib/lib-rcsimssjni.so $vendor_lib/lib-rcsjni.so $vendor_lib/lib-rtpcommon.so $vendor_lib/lib-rtpcore.so $vendor_lib/lib-rtpdaemoninterface.so $vendor_lib/lib-rtpsl.so $vendor_lib/libvcel.so; do

		if [ -e "$FILE" ]; then
			echo 'post_init: delete' $FILE > /dev/kmsg;
			rm -rf $FILE;
		fi;

	done

	echo 'post_init: file deleted for device =' $device '- fsgid =' $fsgid '- radio =' $radio '- cid =' $cid > /dev/kmsg;
else
	echo 'post_init: file not deleted for device =' $device '- fsgid =' $fsgid '- radio =' $radio '- cid =' $cid > /dev/kmsg;
fi;

echo 'post_init: run OK for device =' $device '- fsgid =' $fsgid '- radio =' $radio '- cid =' $cid > /dev/kmsg;

multirom=`cat fstab.qcom | grep 'name/system'`;
mUmount=0;
contains "$multirom" "#" && mUmount=1;

if  [ "$mUmount" == 0 ]; then
	mount -o ro,remount /system;
	echo 'post_init: mount ro OK' $multirom > /dev/kmsg;
else
	echo 'post_init: not mount ro OK' $multirom > /dev/kmsg;
fi

umount /system;

exit
