#include <stdlib.h>

// These are paths to folders in /sys which contain "uevent" file
// need to init this device.
// MultiROM needs to init framebuffer, mmc blocks, input devices,
// some ADB-related stuff and USB drives, if OTG is supported
// You can use * at the end to init this folder and all its subfolders
const char *mr_init_devices[] =
{
    "/sys/class/graphics/fb0",

    "/sys/block/mmcblk0",
    "/sys/devices/msm_sdcc.1",
    "/sys/devices/msm_sdcc.1/mmc_host/mmc0",
    "/sys/devices/msm_sdcc.1/mmc_host/mmc0/mmc0:0001",
    "/sys/devices/msm_sdcc.1/mmc_host/mmc0/mmc0:0001/block/mmcblk0",
    "/sys/devices/msm_sdcc.1/mmc_host/mmc0/mmc0:0001/block/mmcblk0/mmcblk0p37", // boot
    "/sys/devices/msm_sdcc.1/mmc_host/mmc0/mmc0:0001/block/mmcblk0/mmcblk0p39", // cache
    "/sys/devices/msm_sdcc.1/mmc_host/mmc0/mmc0:0001/block/mmcblk0/mmcblk0p1", // modem
    "/sys/devices/msm_sdcc.1/mmc_host/mmc0/mmc0:0001/block/mmcblk0/mmcblk0p22", // persist
    "/sys/devices/msm_sdcc.1/mmc_host/mmc0/mmc0:0001/block/mmcblk0/mmcblk0p40", // system
    "/sys/devices/msm_sdcc.1/mmc_host/mmc0/mmc0:0001/block/mmcblk0/mmcblk0p41", // userdata
    "/sys/devices/msm_sdcc.1/mmc_host/mmc0/mmc0:0001/block/mmcblk0/mmcblk0p17", // metadata
    "/sys/devices/msm_sdcc.1/mmc_host/mmc0/mmc0:0001/block/mmcblk0/mmcblk0p18", // metadata
    "/sys/devices/msm_sdcc.1/mmc_host/mmc0/mmc0:0001/block/mmcblk0/mmcblk0p32", // metadata
    "/sys/devices/msm_sdcc.1/mmc_host/mmc0/mmc0:0001/block/mmcblk0/mmcblk0p36", // recovery
    "/sys/bus/mmc",
    "/sys/bus/mmc/drivers/mmcblk",
    "/sys/module/mmc_core",
    "/sys/module/mmcblk",

    "/sys/devices/gpio_keys.77/input*",
    "/sys/devices/virtual/input*",
    "/sys/devices/virtual/misc/uinput*",
    "/sys/devices/f9966000.i2c/i2c-1/1-004a/input*",

    // for adb
    "/sys/devices/virtual/tty/ptmx*",
    "/sys/devices/virtual/misc/android_adb*",
    "/sys/devices/virtual/android_usb/android0/f_adb*",
    "/sys/bus/usb*",

    // USB drive is in here
    "/sys/devices/platform/xhci-hcd*",

    // Encryption
    "/sys/devices/virtual/misc/device-mapper",
    "/sys/devices/virtual/misc/ion",
    "/sys/devices/virtual/qseecom/qseecom",

    // Logging
    "/sys/devices/virtual/pmsg/pmsg0",
    "/sys/devices/virtual/mem/kmsg",

    "/sys/block/mmcblk1",
    "/sys/block/mmcblk1/mmcblk1p1",
    "/sys/block/mmcblk1/mmcblk1p2",

    "/sys/bus/mmc",
    "/sys/bus/mmc/drivers/mmcblk",
    "/sys/bus/sdio/drivers/bcmsdh_sdmmc",
    "/sys/module/mmc_core",
    "/sys/module/mmcblk",

    "/sys/devices/gpio_keys.76/input*",
    "/sys/devices/platform/android_usb/usb_function_switch",
    "/sys/devices/virtual/input*",
    "/sys/devices/virtual/misc/uinput",
    "/sys/devices/virtual/tty/ptmx",
    "/sys/devices/virtual/misc/android_adb",
    "/sys/devices/virtual/android_usb/android0/f_adb",
    "/sys/bus/usb",
    
    "/sys/devices/f9924000.i2c/i2c-0/0-0020/input*",

    "/sys/devices/platform/xhci-hcd*",

    "/sys/module/msm_thermal/core_control/enabled",

    "/sys/devices/system/cpu",
    "/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor",
    "/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors",
    "/sys/devices/system/cpu/cpu1/online",
    "/sys/devices/system/cpu/cpu2/online",
    "/sys/devices/system/cpu/cpu3/online",
    "/sys/devices/system/cpu/cpu1/cpufreq/scaling_governor",
    "/sys/devices/system/cpu/cpu2/cpufreq/scaling_governor",
    "/sys/devices/system/cpu/cpu3/cpufreq/scaling_governor",
    "/sys/devices/system/cpu/cpufreq/interactive/up_threshold",
    "/sys/devices/system/cpu/cpufreq/interactive/sampling_rate",
    "/sys/devices/system/cpu/cpufreq/interactive/io_is_busy",
    "/sys/devices/system/cpu/cpufreq/interactive/sampling_down_factor",
    "/sys/devices/system/cpu/cpufreq/interactive/down_differential",
    "/sys/devices/system/cpu/cpufreq/interactive/up_threshold_multi_core",
    "/sys/devices/system/cpu/cpufreq/interactive/down_differential_multi_core",
    "/sys/devices/system/cpu/cpufreq/interactive/optimal_freq",
    "/sys/devices/system/cpu/cpufreq/interactive/sync_freq",
    "/sys/devices/system/cpu/cpufreq/interactive/up_threshold_any_cpu_load",
    "/sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq",
    "/sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq",
    "/sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq",
    "/sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq",

    NULL
};
