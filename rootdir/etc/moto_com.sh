#!/system/bin/sh
PATH=/sbin:/system/sbin:/system/bin:/system/xbin
export PATH

mode=`getprop ro.bootmode`
case "$mode" in
	"charger")

	echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
	echo "interactive" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
	echo "interactive" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
	echo "interactive" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
	echo 0 > /sys/devices/system/cpu/cpu1/online
	echo 0 > /sys/devices/system/cpu/cpu2/online
	echo 0 > /sys/devices/system/cpu/cpu3/online

	/system/bin/charge_only_mode

	echo 1 > /sys/devices/system/cpu/cpu1/online
	echo 1 > /sys/devices/system/cpu/cpu2/online
	echo 1 > /sys/devices/system/cpu/cpu3/online
	;;
esac
