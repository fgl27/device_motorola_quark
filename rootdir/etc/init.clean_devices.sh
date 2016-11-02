#!/system/bin/sh

if [ -e /data/tmp ]; then
	echo "init clean on $(date)" > /data/tmp/bootcheck.txt;
else
mkdir /data/tmp;
fi;

if [ -e /system/lib/libsupol.so ] && [ -e /system/xbin/supolicy ]; then
/system/xbin/supolicy --live \
	"allow qti_init_shell selinuxfs:file { write };" \
	"allow qti_init_shell kernel:security { load_policy read_policy };" \
	"allow untrusted_app system_data_file:file { unlink };" \
	"allow untrusted_app cache_file:file { getattr open write };" \
	"allow qti_init_shell block_device:blk_file { open read };" \
	"allow qti_init_shell system_data_file:file { append write };" \
	"allow qti_init_shell labeledfs:filesystem { remount unmount };" \
	"allow qti_init_shell su_exec:file { getattr setattr };" \
	"allow qti_init_shell default_prop:property_service { set };"

	echo "init.clean_devices patch sepolicy" >> /data/tmp/bootcheck.txt;
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
	framework="system/framework";
	lib="system/lib";
	priv_app="system/priv-app";
	vendor_lib="system/vendor/lib";

	for FILE in $app/ims $app/VZWAPNLib $priv_app/AppDirectedSMSProxy $priv_app/BuaContactAdapter $priv_app/VZWAPNService  $bin/imsdatadaemon $bin/imsqmidaemon $etc/com.verizon.hardware.telephony.ehrpd.xml $etc/com.verizon.hardware.telephony.lte.xml $etc/com.verizon.ims.xml  $etc/rcsservice.xml $etc/rcsimssettings.xml $etc/com.motorola.DirectedSMSProxy.xml $etc/com.vzw.vzwapnlib.xml $framework/com.verizon.hardware.telephony.ehrpd.jar $framework/com.verizon.hardware.telephony.lte.jar $framework/com.verizon.ims.jar $framework/rcsimssettings.jar $framework/rcsservice.jar $lib/libimscamera_jni.so $lib/libimsmedia_jni.so $vendor_lib/lib-dplmedia.so $vendor_lib/lib-ims-setting-jni.so $vendor_lib/lib-ims-settings.so $vendor_lib/lib-imsSDP.so $vendor_lib/lib-imsdpl.so $vendor_lib/lib-imsqimf.so $vendor_lib/lib-imsrcs.so $vendor_lib/lib-imss.so $vendor_lib/lib-imsvt.so $vendor_lib/lib-imsxml.so $vendor_lib/lib-rcsimssjni.so $vendor_lib/lib-rcsjni.so $vendor_lib/lib-rtpcommon.so $vendor_lib/lib-rtpcore.so $vendor_lib/lib-rtpdaemoninterface.so $vendor_lib/lib-rtpsl.so $vendor_lib/libvcel.so; do

		if [ -e "$FILE" ]; then 
			rm -rf $FILE;
		fi;

	done

	umount /system;
	echo "init.clean_devices file deleted for device = $device fsgid = $fsgid" >> /data/tmp/bootcheck.txt;
else
	echo "init.clean_devices bn file deleted for device = $device fsgid = $fsgid" >> /data/tmp/bootcheck.txt;
fi;

exit

