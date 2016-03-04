#!/sbin/busybox sh
#script init pull from neobuddy89 github

# Mount root as RW to apply tweaks and settings
mount -o remount,rw /;
mount -o rw,remount /system

# Make tmp folder
mkdir /tmp;

# Give permissions to execute
chown -R root:system /tmp/;
chmod -R 777 /tmp/;
chmod 6755 /sbin/*;
chmod 6755 /system/xbin/*;
echo "BHB Boot initiated on $(date)" > /tmp/bootcheck;

# Tune LMK with values we love
#echo "1536,2048,4096,16384,28672,32768" > /sys/module/lowmemorykiller/parameters/minfree
#echo 32 > /sys/module/lowmemorykiller/parameters/cost

#enable, disable and tweak some features of the kernel by default for better performance vs battery

# Thremal - Disable msm core cotrol it doesnot work with intellitermal
echo 0 > /sys/module/msm_thermal/core_control/enabled

# CPU - Disable hotplug boost
echo 0 > /sys/module/cpu_boost/parameters/hotplug_boost

# CPU - set max clock to sotck value
chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo 2649600 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chmod 444 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq

chmod 644 /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
echo 2649600 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chmod 444 /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq

chmod 644 /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
echo 2649600 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chmod 444 /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq

chmod 644 /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
echo 2649600 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chmod 444 /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq

# CPU - Set umbrela_core as CPU_GOV 
chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo umbrella_core > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
chmod 444 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

echo 1 > /sys/devices/system/cpu/cpu1/online
chmod 644 /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo umbrella_core > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
chmod 444 /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor

echo 1 > /sys/devices/system/cpu/cpu2/online
chmod 644 /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo umbrella_core > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
chmod 444 /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor

echo 1 > /sys/devices/system/cpu/cpu3/online
chmod 644 /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
echo umbrella_core > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
chmod 444 /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor

# Misc disable Fsync
echo N > /sys/module/sync/parameters/fsync_
# Wake - enable dt2w and s2w by default
echo 1 > /sys/android_touch2/doubletap2wake
echo 5 > /sys/android_touch2/sweep2wake

# GPU max clock to sotck value, enable simple gpu algorithm
echo 600000000 > /sys/devices/fdb00000.qcom,kgsl-3d0/kgsl/kgsl-3d0/max_gpuclk
echo 1 > /sys/module/simple_gpu_algorithm/parameters/simple_gpu_activate

# LMK -  enable Adaptive LMK
echo 1 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
echo 53059 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
echo 1 > /sys/module/process_reclaim/parameters/enable_process_reclaim
echo 100 > /sys/module/process_reclaim/parameters/pressure_max

# Virtual memory - Tweak VM
echo 20 > /proc/sys/vm/dirty_background_ratio
echo 200 > /proc/sys/vm/dirty_expire_centisecs
echo 40 > /proc/sys/vm/dirty_ratio
echo 0 > /proc/sys/vm/swappiness
echo 80 > /proc/sys/vm/vfs_cache_pressure

exit;
