#!/system/bin/sh

mount -o rw,remount /system

#patch sepolicy need for N for now, use a cp and name change workaround to prevent security breach
if [ -e /system/etc/sp/sp_lib ] && [ -e /system/etc/sp/sp_bin ]; then
cp /system/etc/sp/sp_lib /system/etc/sp/libsupol.so
chmod 755 /system/etc/sp/libsupol.so
chmod 755 /system/etc/sp/sp_bin
LD_LIBRARY_PATH=/system/etc/sp/ /system/etc/sp/sp_bin --live \
	"allow init shell_exec:file { execute_no_trans };" \
	"allow init system_file:file { execute_no_trans };" \
	"allow init thermal-engine_exec:file { execute_no_trans };" \
	"allow priv_app anr_data_file:dir { read };" \
	"allow priv_app su_exec:file { execute write getattr setattr execute_no_trans };" \
	"allow priv_app sudaemon:unix_stream_socket { connectto };" \
	"allow priv_app superuser_device:sock_file { write };" \
	"allow priv_app system_data_file:file { getattr open read };" \
	"allow qti_init_shell block_device:blk_file { open read };" \
	"allow qti_init_shell default_prop:property_service { set };" \
	"allow qti_init_shell kernel:security { load_policy read_policy };" \
	"allow qti_init_shell labeledfs:filesystem { remount unmount };" \
	"allow qti_init_shell selinuxfs:file { write };" \
	"allow qti_init_shell su_exec:file { getattr setattr };" \
	"allow qti_init_shell system_data_file:file { append write };" \
	"allow toolbox default_prop:property_service { set };" \
	"allow toolbox labeledfs:filesystem { remount };" \
	"allow toolbox system_file:dir { add_name write };" \
	"allow toolbox system_file:file { create setattr write };" \
	"allow untrusted_app anr_data_file:dir { open read };" \
	"allow untrusted_app cache_file:file { getattr open write };" \
	"allow untrusted_app su_exec:file { execute write getattr setattr execute_no_trans };" \
	"allow untrusted_app sudaemon:unix_stream_socket { connectto };" \
	"allow untrusted_app superuser_device:sock_file { write };" \
	"allow untrusted_app system_data_file:file { getattr open read unlink };"

	echo 'post_init: patch sepolicy ok' > /dev/kmsg;

rm -rf /system/etc/sp/libsupol.so
chmod 444 /system/etc/sp/sp_bin
chmod 444 /system/etc/sp/sp_lib
fi;

# Adaway only present in some ROM this need to be 755 to execute it libs...
if [ -e /system/app/Adaway/lib/arm/libblank_webserver_exec.so ]; then
	chmod 755 /system/app/Adaway/lib/arm/libblank_webserver_exec.so
fi

if [ -e /system/app/Adaway/lib/arm/libtcpdump_exec.so ]; then
	chmod 755 /system/app/Adaway/lib/arm/libtcpdump_exec.so
fi

# Isu support
if [ -e /system/bin/temp_su ]; then
	mv /system/bin/temp_su /system/bin/su
fi

if [ -e /system/xbin/isu ]; then
	mv /system/xbin/isu /system/xbin/su
	if [ ! -e /system/bin/su ]; then
		ln -s -f /system/xbin/su /system/bin/su
	fi
# Isu end
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

	# stop IMS services Not need for others then VZW users * have disable volte.rc when they are enable remove the #
#	stop imsqmidaemon;
#	stop imsdatadaemon;
#	setprop net.lte.volte_call_capable false

	# delete main folders
	app="system/app";
	bin="system/bin";
	etc="system/etc/permissions";
	framework="system/framework";
	lib="system/lib";
	priv_app="system/priv-app";
	vendor_lib="system/vendor/lib";

	# delete vzw only files
	for FILE in $app/ims $app/RCSBootstraputil $app/RcsImsBootstraputil $app/VZWAPNLib $priv_app/AppDirectedSMSProxy $priv_app/BuaContactAdapter $priv_app/VZWAPNService $bin/imsdatadaemon $bin/ims_rtp_daemon $bin/imsqmidaemon $etc/com.verizon.hardware.telephony.ehrpd.xml $etc/com.verizon.hardware.telephony.lte.xml $etc/com.verizon.ims.xml  $etc/rcsservice.xml $etc/rcsimssettings.xml $etc/com.motorola.DirectedSMSProxy.xml $etc/com.vzw.vzwapnlib.xml $framework/com.motorola.ims.rcsmanager.jar $framework/com.verizon.hardware.telephony.ehrpd.jar $framework/com.verizon.hardware.telephony.lte.jar $framework/com.verizon.ims.jar $framework/rcsimssettings.jar $framework/rcsservice.jar $lib/libimscamera_jni.so $lib/libimsmedia_jni.so $vendor_lib/lib-dplmedia.so $vendor_lib/lib-ims-setting-jni.so $vendor_lib/lib-ims-settings.so $vendor_lib/lib-imsSDP.so $vendor_lib/lib-imsdpl.so $vendor_lib/lib-imsqimf.so $vendor_lib/lib-imsrcs.so $vendor_lib/lib-imss.so $vendor_lib/lib-imsvt.so $vendor_lib/lib-imsxml.so $vendor_lib/lib-rcsimssjni.so $vendor_lib/lib-rcsjni.so $vendor_lib/lib-rtpcommon.so $vendor_lib/lib-rtpcore.so $vendor_lib/lib-rtpdaemoninterface.so $vendor_lib/lib-rtpsl.so $vendor_lib/libvcel.so; do

		if [ -e "$FILE" ]; then 
			rm -rf $FILE;
		fi;

	done

	echo 'post_init: file deleted for device =' $device '- fsgid =' $fsgid '- radio =' $radio '- cid =' $cid > /dev/kmsg;
else
	echo 'post_init: file not deleted for device =' $device '- fsgid =' $fsgid '- radio =' $radio '- cid =' $cid > /dev/kmsg;
fi;

echo 'post_init: run OK for device =' $device '- fsgid =' $fsgid '- radio =' $radio '- cid =' $cid > /dev/kmsg;

mount -o ro,remount /system;
umount /system;

exit

