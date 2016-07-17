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

#enable, disable and tweak some features of the kernel by default for better performance vs battery

# CPU - Disable hotplug boost
echo 0 > /sys/module/cpu_boost/parameters/hotplug_boost

# CPU - set max clock to sotck value
chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo 2649600 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chmod 444 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq

chmod 644 /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
echo 2649600 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
chmod 444 /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq

chmod 644 /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
echo 2649600 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
chmod 444 /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq

chmod 644 /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
echo 2649600 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
chmod 444 /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq

# GPU max clock to stock value, enable adreno_idler
echo 600000000 > /sys/devices/fdb00000.qcom,kgsl-3d0/kgsl/kgsl-3d0/max_gpuclk
echo Y > /sys/module/adreno_idler/parameters/adreno_idler_active


echo "Post init Kernel Boot initiated on $(date)" >> /tmp/bootcheck.txt

exit
