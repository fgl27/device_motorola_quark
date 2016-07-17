#!/system/bin/sh
#script init pull from neobuddy89 github

# Mount root as RW to apply tweaks and settings
mount -o remount,rw /
mount -o rw,remount /system

# Give permissions to execute
chmod -R 777 /tmp/
chmod 6755 /sbin/*
chmod 6755 /system/xbin/*

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

echo "post-init-ROM Boot initiated on $(date)" >> /tmp/bootcheck.txt

exit

