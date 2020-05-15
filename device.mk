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
#

LOCAL_PATH := device/motorola/quark

DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay-lineage

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# Inherit from quark device
$(call inherit-product, vendor/motorola/quark/quark-vendor.mk)

# Overlay
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

# Device identifier. This must come after all inclusions
PRODUCT_RELEASE_NAME := Moto MAXX
PRODUCT_DEVICE := quark
PRODUCT_BRAND := motorola
PRODUCT_MODEL := quark
PRODUCT_MANUFACTURER := motorola

TARGET_VENDOR := motorola
PRODUCT_GMS_CLIENTID_BASE := android-motorola

PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_BUILD_FLAVOR=quark-$(TARGET_BUILD_VARIANT)

# Screen density
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := 560dpi
PRODUCT_AAPT_PREBUILT_DPI := 560dpi xxxhdpi xxhdpi xhdpi hdpi

# Bin scripts
PRODUCT_PACKAGES += \
    rcs_config.sh

# Boot animation
TARGET_SCREEN_HEIGHT := 2560
TARGET_SCREEN_WIDTH := 1440

# No SDCard
PRODUCT_CHARACTERISTICS := nosdcard

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/com.android.nfc_extras.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.android.nfc_extras.xml \
    frameworks/native/data/etc/com.nxp.mifare.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.nxp.mifare.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_0_3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.software.webview.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.webview.xml \
    frameworks/native/data/etc/android.software.voice_recognizers.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.voice_recognizers.xml

# Motorola-specific permissions
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/permissions/com.motorola.actions.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.motorola.actions.xml \
    $(LOCAL_PATH)/permissions/com.motorola.android.dm.service.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.motorola.android.dm.service.xml \
    $(LOCAL_PATH)/permissions/com.motorola.android.encryption_library.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.motorola.android.encryption_library.xml \
    $(LOCAL_PATH)/permissions/com.motorola.android.settings.shared.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.motorola.android.settings.shared.xml \
    $(LOCAL_PATH)/permissions/com.motorola.aon.quickpeek.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.motorola.aon.quickpeek.xml \
    $(LOCAL_PATH)/permissions/com.motorola.aov.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.motorola.aov.xml \
    $(LOCAL_PATH)/permissions/com.motorola.camera.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.motorola.camera.xml \
    $(LOCAL_PATH)/permissions/com.motorola.camerabgproc_library.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.motorola.camerabgproc_library.xml \
    $(LOCAL_PATH)/permissions/com.motorola.commandcenter.library.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.motorola.commandcenter.library.xml \
    $(LOCAL_PATH)/permissions/com.motorola.device.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.motorola.device.xml \
    $(LOCAL_PATH)/permissions/com.motorola.email.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.motorola.email.xml \
    $(LOCAL_PATH)/permissions/com.motorola.frameworks.core.addon.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.motorola.frameworks.core.addon.xml \
    $(LOCAL_PATH)/permissions/com.motorola.gallery.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.motorola.gallery.xml \
    $(LOCAL_PATH)/permissions/com.motorola.haptic.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.motorola.haptic.xml \
    $(LOCAL_PATH)/permissions/com.motorola.moto.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.motorola.moto.xml \
    $(LOCAL_PATH)/permissions/com.motorola.motodisplay.pd.screenoff.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.motorola.motodisplay.pd.screenoff.xml \
    $(LOCAL_PATH)/permissions/com.motorola.motosignature.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.motorola.motosignature.xml \
    $(LOCAL_PATH)/permissions/com.motorola.sensorhub.stm401.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.motorola.sensorhub.stm401.xml \
    $(LOCAL_PATH)/permissions/com.motorola.slpc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.motorola.slpc.xml \
    $(LOCAL_PATH)/permissions/com.motorola.software.bodyguard.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.motorola.software.bodyguard.xml \
    $(LOCAL_PATH)/permissions/com.motorola.software.droid_line.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.motorola.software.droid_line.xml \
    $(LOCAL_PATH)/permissions/com.motorola.software.folio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.motorola.software.folio.xml \
    $(LOCAL_PATH)/permissions/com.motorola.software.guideme.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.motorola.software.guideme.xml \
    $(LOCAL_PATH)/permissions/com.motorola.software.smartnotifications.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.motorola.software.smartnotifications.xml \
    $(LOCAL_PATH)/permissions/com.motorola.targetnotif.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.motorola.targetnotif.xml \
    $(LOCAL_PATH)/permissions/com.motorola.zap.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.motorola.zap.xml

# APEX
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/ld.config.txt:$(TARGET_COPY_OUT_SYSTEM)/etc/swcodec/ld.config.txt

# Audio
PRODUCT_PACKAGES += \
    audio.a2dp.default \
    audio_policy.apq8084 \
    audio.primary.apq8084 \
    audio.r_submix.default \
    audio.usb.default \
    libaudio-resampler \
    libqcompostprocbundle \
    libqcomvisualizer \
    libqcomvoiceprocessing \
    libqcomvoiceprocessingdescriptors \
    libgenlock \
    libqdutils \
    libqservice \
    libtinyxml \
    cplay \
    tinycap \
    tinypcminfo \
    tinyplay

PRODUCT_PACKAGES += \
    mbhc.bin \
    wcd9310_anc.bin

# Audio configuration
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    $(LOCAL_PATH)/audio/audio_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_platform_info.xml \
    $(LOCAL_PATH)/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(LOCAL_PATH)/audio/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml \

PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml

# Bluetooth
PRODUCT_PACKAGES += \
     libbt-vendor.apq8084

# Browser
PRODUCT_PACKAGES += \
    Jelly

# Camera
PRODUCT_PACKAGES += \
    camera.apq8084 \
    libshims_fence

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/external_camera_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/external_camera_config.xml

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/hacks/hdrhax:$(TARGET_COPY_OUT_VENDOR)/etc/hdrhax

# Charger
PRODUCT_PACKAGES += \
    charger \
    charger_res_images \
    animation \
    battery_fail \
    battery_scale \
    font_log

# LineageActions
PRODUCT_PACKAGES += \
    LineageActions \
    libjni_LineageActions

# CNE
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/andsfCne.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/cne/andsfCne.xml \
    $(LOCAL_PATH)/configs/SwimConfig.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/cne/SwimConfig.xml

PRODUCT_PACKAGES += \
    libcnefeatureconfig

# CRDA
PRODUCT_PACKAGES += \
    crda \
    linville.key.pub.pem \
    regdbdump \
    regulatory.bin

# Dexopt
$(call add-product-dex-preopt-module-config,MotoSignatureApp,disable)

PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI

# Display
PRODUCT_PACKAGES += \
    copybit.apq8084 \
    gralloc.apq8084 \
    hwcomposer.apq8084 \
    libgenlock \
    memtrack.apq8084 \
    hdmi_cec.apq8084

# GPS
PRODUCT_PACKAGES += \
    gps.apq8084 \
    libgps.utils \
    libloc_core \
    libloc_eng

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/gps/etc/flp.conf:$(TARGET_COPY_OUT_SYSTEM)/etc/flp.conf \
    $(LOCAL_PATH)/gps/etc/gps.conf:$(TARGET_COPY_OUT_SYSTEM)/etc/gps.conf \
    $(LOCAL_PATH)/gps/etc/izat.conf:$(TARGET_COPY_OUT_SYSTEM)/etc/izat.conf \
    $(LOCAL_PATH)/gps/etc/sap.conf:$(TARGET_COPY_OUT_SYSTEM)/etc/sap.conf \
    $(LOCAL_PATH)/gps/etc/quipc.conf:$(TARGET_COPY_OUT_SYSTEM)/etc/quipc.conf

# IDC
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/idc/atmel_mxt_ts.idc:$(TARGET_COPY_OUT_SYSTEM)/usr/idc/atmel_mxt_ts.idc

# IRSC
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/sec_config:$(TARGET_COPY_OUT_VENDOR)/etc/sec_config

# Keylayout
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/keylayout/apq8084-taiko-tfa9890_stereo_co_Button_Jack.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/apq8084-taiko-tfa9890_stereo_co_Button_Jack.kl \
    $(LOCAL_PATH)/keylayout/sensorprocessor.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/sensorprocessor.kl \
    $(LOCAL_PATH)/keylayout/atmel_mxt_ts.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/atmel_mxt_ts.kl

# Keystore
PRODUCT_PACKAGES += \
    keystore.apq8084

# Lights
PRODUCT_PACKAGES += \
    lights.apq8084

# Media
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/media/media_profiles_V1_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml \
    $(LOCAL_PATH)/media/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    $(LOCAL_PATH)/media/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml


# NFC
PRODUCT_PACKAGES += \
    com.android.nfc_extras \
    nfc_nci.bcm2079x.default \
    NfcNci \
    Tag

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.nfc.xml \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.nfc.hcef.xml \
    $(LOCAL_PATH)/configs/nfcee_access.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/nfcee_access.xml \
    $(LOCAL_PATH)/configs/libnfc-nci.conf:$(TARGET_COPY_OUT_SYSTEM)/etc/libnfc-nci.conf \
    $(LOCAL_PATH)/configs/libnfc-nci-20795a10.conf:$(TARGET_COPY_OUT_SYSTEM)/etc/libnfc-nci-20795a10.conf

# OMX
PRODUCT_PACKAGES += \
    libc2dcolorconvert \
    libOmxAacEnc \
    libOmxAmrEnc \
    libOmxCore \
    libOmxEvrcEnc \
    libOmxQcelp13Enc \
    libOmxVdec \
    libOmxVenc \
    libOmxVdpp \
    libstagefrighthw

# Ramdisk
PRODUCT_PACKAGES += \
    fstab.qcom \
    init.mmi.boot.sh \
    init.mmi.touch.sh \
    init.mmi.usb.sh \
    init.qcom.post_boot.sh \
    init.qcom.rc \
    init.qcom.power.rc \
    init.qcom.usb.rc \
    init.recovery.qcom.rc \
    ueventd.qcom.rc

# RIL
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/dsi_config.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/data/dsi_config.xml \
    $(LOCAL_PATH)/configs/netmgr_config.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/data/netmgr_config.xml \
    $(LOCAL_PATH)/configs/qcril.db:$(TARGET_COPY_OUT_SYSTEM)/etc/motorola/qcril.db \
    $(LOCAL_PATH)/configs/qmi_config.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/data/qmi_config.xml

PRODUCT_PACKAGES += \
    librmnetctl

# System Properties
include $(LOCAL_PATH)/system_prop.mk

# Shippig API
$(call inherit-product, $(SRC_TARGET_DIR)/product/product_launched_with_k.mk)

# Support
PRODUCT_PACKAGES += \
    libcurl \
    libxml2

# RIL Shim
PRODUCT_PACKAGES += \
    libqsapshim \
    libqsap_sdk

# Soong
PRODUCT_SOONG_NAMESPACES += $(LOCAL_PATH)

#Time
PRODUCT_PACKAGES += \
    libcommon_time_client

# Thermal
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/thermal-engine-quark.conf:$(TARGET_COPY_OUT_VENDOR)/etc/thermal-engine-quark.conf

# Torch
PRODUCT_PACKAGES += \
    Torch

# Wifi
PRODUCT_PACKAGES += \
    hostapd \
    libnetcmdiface \
    wpa_supplicant \
    libwpa_client \
    wcnss_service \
    wpa_supplicant.conf

PRODUCT_PACKAGES += \
    WCNSS_qcom_cfg.ini \
    WCNSS_qcom_wlan_nv.bin \
    wlan_mac.bin \
    wlan_mac_serial.bin \
    qca_cld_wlan.ko


PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/hostapd.accept:$(TARGET_COPY_OUT_SYSTEM)/etc/hostapd/hostapd.accept \
    $(LOCAL_PATH)/configs/hostapd.deny:$(TARGET_COPY_OUT_SYSTEM)/etc/hostapd/hostapd.deny \
    $(LOCAL_PATH)/configs/hostapd_default.conf:$(TARGET_COPY_OUT_SYSTEM)/etc/hostapd/hostapd_default.conf

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
    $(LOCAL_PATH)/configs/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/wifi/WCNSS_cfg.dat:$(TARGET_COPY_OUT_VENDOR)/firmware/WCNSS_cfg.dat \
    $(LOCAL_PATH)/wifi/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/firmware/WCNSS_qcom_cfg.ini \
    $(LOCAL_PATH)/wifi/WCNSS_qcom_wlan_nv.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/WCNSS_qcom_wlan_nv.bin


#android_filesystem_config.h
PRODUCT_PACKAGES += \
    fs_config_files

# HIDL packages
$(call inherit-product, device/motorola/quark/hidl.mk)

# loggy enable this when debuggin gon permissive
#PRODUCT_PACKAGES += \
#    loggy.sh

# Reduce system image size by limiting java debug info.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# TimeKeep
PRODUCT_PACKAGES += \
    timekeep \
    TimeKeep
