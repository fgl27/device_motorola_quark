#!/system/bin/sh

mount -o rw,remount /system


# Make tmp folder
if [ -e /data/tmp ]; then
	echo "data/tmp already exist"
else
mkdir /data/tmp
fi

# only present on RR this need to be 755 to execute...
if [ -e /system/app/Adaway/lib/arm/libblank_webserver_exec.so ]; then
	
	chmod 755 /system/app/Adaway/lib/arm/libblank_webserver_exec.so

fi

if [ -e /system/app/Adaway/lib/arm/libtcpdump_exec.so ]; then
	
	chmod 755 /system/app/Adaway/lib/arm/libtcpdump_exec.so

fi

if [ -e /system/bin/isu ]; then
	
	mv /system/bin/isu /system/bin/su

fi

if [ -e /system/xbin/isu ]; then
	
	mv /system/xbin/isu /system/xbin/su

fi

# give su root:root to adb su work
if [ -e /system/xbin/su ]; then
	
	chown root:root /system/xbin/su

fi

fsgid=`getprop ro.boot.fsg-id`;
device=`getprop ro.boot.hardware.sku`

if  [ "$device" == XT1225 ] ||  [ "$fsgid" == emea ] || [ "$fsgid" == singlela ]; then
	# stop IMS services Not need for others then VZW users
	stop imsqmidaemon;
	stop imsdatadaemon;
	setprop net.lte.volte_call_capable false
	echo "services stop okay device = $device fsgid = $fsgid" >> /data/tmp/bootcheck.txt;

else
	echo "services not stoped for device = $device fsgid = $fsgid" >> /data/tmp/bootcheck.txt;
fi;

echo "post-init-ROM Boot initiated on $(date)" >> /data/tmp/bootcheck.txt
umount /system;
exit

