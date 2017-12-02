#!/system/bin/sh
mount -o ro,remount /system;
echo 'post_init_c: run OK' > /dev/kmsg;
exit
