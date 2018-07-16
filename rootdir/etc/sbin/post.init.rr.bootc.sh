#!/system/bin/sh
mount -o ro,remount /system;
echo 'post_init_c: run OK' > /dev/kmsg;

# Start zram
echo 0 > /proc/sys/vm/page-cluster
echo 25 > /proc/sys/vm/swappiness
#size is 25% = 768 = 768 * 1024 * 1024 = 805306368
echo 805306368 > /sys/block/zram0/disksize
mkswap /dev/block/zram0
swapon /dev/block/zram0

exit
