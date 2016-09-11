#!/system/bin/sh
#script init pull from neobuddy89 github

# Mount root as RW to apply tweaks and settings
mount -o remount,rw /
mount -o rw,remount /system

# Give permissions to execute
chmod -R 777 /tmp/
chmod 6755 /sbin/*
chmod 6755 /system/xbin/*

# give su root:root to adb su work
chown root:root /system/xbin/su

# Make tmp folder
if [ -e /tmp ]; then
	echo "tmp already exist"
else
mkdir /tmp
fi

# only present on RR this need to be 755 to execute...
if [ -e /system/app/Adaway/lib/arm/libblank_webserver_exec.so ]; then
	chmod 755 /system/app/Adaway/lib/arm/libblank_webserver_exec.so
fi

if [ -e /system/app/Adaway/lib/arm/libtcpdump_exec.so ]; then
	chmod 755 /system/app/Adaway/lib/arm/libtcpdump_exec.so
fi

fsgid=`getprop ro.boot.fsg-id`;

if  [ "$fsgid" != verizon ]; then
	# stop IMS services Not need for others then VZW users
	stop imsqmidaemon;
	stop imsdatadaemon;
	echo "services stop okay device fsgid = $fsgid" >> /tmp/bootcheck.txt;

else
	echo "services not stoped for fsgid = $fsgid" >> /tmp/bootcheck.txt;
fi;

echo "post-init-ROM Boot initiated on $(date)" >> /tmp/bootcheck.txt

exit

