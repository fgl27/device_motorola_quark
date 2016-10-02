#!/system/bin/sh
#script init pull from neobuddy89 github

# give su root:root to adb su work
if [ -e /system/xbin/su ]; then
	mount -o rw,remount /system
	chown root:root /system/xbin/su
	umount /system;
fi

# Make tmp folder
if [ -e /data/tmp ]; then
	echo "data/tmp already exist"
else
mkdir /data/tmp
fi

# only present on RR this need to be 755 to execute...
if [ -e /system/app/Adaway/lib/arm/libblank_webserver_exec.so ]; then
	mount -o rw,remount /system
	chmod 755 /system/app/Adaway/lib/arm/libblank_webserver_exec.so
	umount /system;
fi

if [ -e /system/app/Adaway/lib/arm/libtcpdump_exec.so ]; then
	mount -o rw,remount /system
	chmod 755 /system/app/Adaway/lib/arm/libtcpdump_exec.so
	umount /system;
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

exit

