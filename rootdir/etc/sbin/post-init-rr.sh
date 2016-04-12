#!/sbin/busybox sh
#script init pull from neobuddy89 github

# Mount root as RW to apply tweaks and settings
mount -o remount,rw /;
mount -o rw,remount /system

# Make tmp folder
if [ -e /tmp]; then
	echo "tmp already exist"
else
mkdir /tmp;
fi

# Give permissions to execute
chmod -R 777 /tmp/;
chmod 6755 /sbin/*;
chmod 6755 /system/xbin/*;
echo "RR-ROM Boot initiated on $(date)" > /tmp/bootcheck-rr;

# Install Busybox
/sbin/busybox --install -s /sbin

# Init.d Support
/sbin/busybox run-parts /system/etc/init.d

exit;
