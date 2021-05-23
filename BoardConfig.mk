#
# Copyright (C) 2015 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# inherit from the proprietary version
-include vendor/motorola/quark/BoardConfigVendor.mk 

QUARK_PATH := device/motorola/quark

BOARD_VENDOR := motorola-qcom

# AIDs and CAPS
TARGET_ALLOW_LEGACY_AIDS := true
TARGET_FS_CONFIG_GEN += \
    $(QUARK_PATH)/fs_config/config.fs \
    $(QUARK_PATH)/fs_config/mot_aids.fs \
    $(QUARK_PATH)/fs_config/file_caps.fs

# Assert
# TODO remove device ,,
TARGET_OTA_ASSERT_DEVICE := quark,quark_lra,quark_umts,quark_verizon,xt1225,xt1250,,xt1254
BOARD_USES_QCOM_HARDWARE := true

# Platform
TARGET_BOARD_PLATFORM := apq8084
TARGET_BOARD_PLATFORM_GPU := qcom-adreno420

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := APQ8084
TARGET_NO_BOOTLOADER := true

# Architecture
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := krait

# Kernel
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_CMDLINE := console=none
BOARD_KERNEL_CMDLINE += androidboot.hardware=qcom ehci-hcd.park=3
BOARD_KERNEL_CMDLINE += utags.blkdev=/dev/block/platform/msm_sdcc.1/by-name/utags
BOARD_KERNEL_CMDLINE += utags.backup=/dev/block/platform/msm_sdcc.1/by-name/utagsBackup
BOARD_KERNEL_CMDLINE += coherent_pool=8M vmalloc=400M
#BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive
BOARD_KERNEL_IMAGE_NAME := zImage-dtb
BOARD_KERNEL_PAGESIZE :=  4096
BOARD_KERNEL_TAGS_OFFSET := 0x01000000
BOARD_RAMDISK_OFFSET     := 0x00000100
BOARD_MKBOOTIMG_ARGS := --ramdisk_offset $(BOARD_RAMDISK_OFFSET) --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
TARGET_KERNEL_CONFIG := quark_defconfig
TARGET_KERNEL_SOURCE := kernel/motorola/apq8084

# IPA
USE_DEVICE_SPECIFIC_DATA_IPA_CFG_MGR := true

# Init
TARGET_INIT_VENDOR_LIB := //$(QUARK_PATH):libinit_apq8084
TARGET_RECOVERY_DEVICE_MODULES := //$(QUARK_PATH):libinit_apq8084
TARGET_NR_SVC_SUPP_GIDS := 28

# Audio
AUDIO_FEATURE_ENABLED_ANC_HEADSET := true
AUDIO_FEATURE_ENABLED_EXTERNAL_SPEAKER := true
AUDIO_FEATURE_ENABLED_EXTENDED_COMPRESS_FORMAT := true
AUDIO_FEATURE_ENABLED_EXTN_FORMATS := true
AUDIO_FEATURE_ENABLED_FLUENCE := true
AUDIO_FEATURE_ENABLED_HFP := true
AUDIO_FEATURE_ENABLED_HWDEP_CAL := true
AUDIO_FEATURE_ENABLED_LOW_LATENCY_CAPTURE := true
AUDIO_FEATURE_ENABLED_MULTI_VOICE_SESSIONS := true
AUDIO_FEATURE_ENABLED_NEW_SAMPLE_RATE := true
AUDIO_FEATURE_ENABLED_PROXY_DEVICE := true
AUDIO_FEATURE_ENABLED_USBAUDIO := true
AUDIO_FEATURE_LOW_LATENCY_PRIMARY := true
BOARD_USES_TINY_ALSA_AUDIO := true
BOARD_USES_ALSA_AUDIO := true
USE_CUSTOM_AUDIO_POLICY := 1
USE_XML_AUDIO_POLICY_CONF := 1

#blobs
TARGET_NEEDS_PLATFORM_TEXT_RELOCATIONS := true

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(QUARK_PATH)/bluetooth
BOARD_HAVE_BLUETOOTH_QCOM := true
BOARD_HAS_QCA_BT_ROME := true
QCOM_BT_USE_BTNV := true
QCOM_BT_USE_OLD_WCNSS_FILTER := true

# Camera
BOARD_GLOBAL_CFLAGS += -DCAMERA_VENDOR_L_COMPAT
TARGET_HAS_LEGACY_CAMERA_HAL1 := true
USE_DEVICE_SPECIFIC_CAMERA := true
TARGET_PROCESS_SDK_VERSION_OVERRIDE += \
    /system/vendor/bin/mm-qcamera-daemon=22 \
    /vendor/bin/mm-qcamera-daemon=22

# Display
MAX_EGL_CACHE_KEY_SIZE := 12*1024
MAX_EGL_CACHE_SIZE := 2048*1024
TARGET_USE_COMPAT_GRALLOC_ALIGN := true
SF_PRIMARY_DISPLAY_ORIENTATION := 180
TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS := 0x02000000U | 0x02002000U
TARGET_DISABLE_POSTRENDER_CLEANUP := true

# HIDL
DEVICE_MANIFEST_FILE += $(QUARK_PATH)/manifest.xml

# Healthd
BACKLIGHT_PATH := "/sys/class/leds/lcd-backlight/brightness"

# Memfd
TARGET_HAS_MEMFD_BACKPORT := true

# Motorola
TARGET_USES_MOTOROLA_LOG := true

# Power
TARGET_USES_INTERACTION_BOOST := true
TARGET_TAP_TO_WAKE_NODE := "/sys/android_touch/doubletap2wake"

# Lights
TARGET_PROVIDES_LIBLIGHT := true

# Media
TARGET_USES_ION := true
# Fix video autoscaling on old OMX decoders
TARGET_OMX_LEGACY_RESCALING := true

# Radio
BOARD_USES_CUTBACK_IN_RILD := true

# Recovery
TARGET_RECOVERY_FSTAB := $(QUARK_PATH)/rootdir/etc/fstab.qcom
BOARD_USE_CUSTOM_RECOVERY_FONT := \"roboto_23x41.h\"
TARGET_RECOVERY_DENSITY := xhdpi

# Security Patch Level
VENDOR_SECURITY_PATCH := 2018-01-01

# SELinux
include device/qcom/sepolicy-legacy/sepolicy.mk

BOARD_VENDOR_SEPOLICY_DIRS += $(QUARK_PATH)/sepolicy
BOARD_PLAT_PRIVATE_SEPOLICY_DIR += $(QUARK_PATH)/sepolicy/private

# Wifi
BOARD_HAS_QCOM_WLAN := true
BOARD_HAS_QCOM_WLAN_SDK := true
BOARD_WLAN_DEVICE := qcwcn
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
WIFI_DRIVER_FW_PATH_STA := "sta"
WIFI_DRIVER_FW_PATH_AP := "ap"
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
WPA_SUPPLICANT_VERSION := VER_0_8_X

# Vold
TARGET_HW_DISK_ENCRYPTION := false
BOARD_VOLD_DISC_HAS_MULTIPLE_MAJORS := true
BOARD_VOLD_EMMC_SHARES_DEV_MAJOR := true
BOARD_VOLD_MAX_PARTITIONS := 40

# Partitions (set for 64 GB)
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_BOOTIMAGE_PARTITION_SIZE := 16777216
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 16793600
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2147483648
BOARD_USERDATAIMAGE_PARTITION_SIZE := 57185009664
BOARD_CACHEIMAGE_PARTITION_SIZE := 3539992576
BOARD_ROOT_EXTRA_FOLDERS := firmware fsg persist
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_FLASH_BLOCK_SIZE := 131072

# APEX
TARGET_FLATTEN_APEX := true

# Enable real time lockscreen charging current values
BOARD_GLOBAL_CFLAGS += -DBATTERY_REAL_INFO

# Compile libhwui in performance mode
HWUI_COMPILE_FOR_PERF := true

# Qualcomm support
TARGET_USES_QCOM_BSP := true
BOARD_GLOBAL_CFLAGS += -DQCOM_BSP
BOARD_GLOBAL_CPPFLAGS += -DQCOM_BSP

# Dexpreopt
DONT_DEXPREOPT_PREBUILTS := true
WITH_DEXPREOPT_DEBUG_INFO := false

# Boot animation
TARGET_BOOTANIMATION_HALF_RES := true

# Binder API version
TARGET_USES_64_BIT_BINDER := true

# Shims
TARGET_LD_SHIM_LIBS := \
   /system/lib/hw/camera.vendor.apq8084.so|libshims_fence.so \
   /system/vendor/lib/libcne.so|libcutils_shim.so \
   /system/vendor/lib/libril-qc-qmi-1.so|libaudioclient_shim.so

# Netmgrd
TARGET_USES_PRE_UPLINK_FEATURES_NETMGRD := true

