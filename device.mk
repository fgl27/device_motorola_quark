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

$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

$(call inherit-product, vendor/motorola/quark/quark-vendor.mk)

LOCAL_PATH := device/motorola/quark

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
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:system/vendor/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/vendor/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/vendor/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/vendor/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/vendor/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/vendor/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/vendor/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/vendor/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/vendor/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/vendor/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:system/vendor/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:system/vendor/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/vendor/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:system/vendor/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/vendor/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/vendor/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/vendor/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/vendor/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/vendor/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/vendor/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/com.android.nfc_extras.xml:system/vendor/etc/permissions/com.android.nfc_extras.xml \
    frameworks/native/data/etc/com.nxp.mifare.xml:system/vendor/etc/permissions/com.nxp.mifare.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:system/vendor/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:system/vendor/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-0.xml:system/vendor/etc/permissions/android.hardware.vulkan.level.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_0_3.xml:system/vendor/etc/permissions/android.hardware.vulkan.version.xml \
    frameworks/native/data/etc/android.software.midi.xml:system/vendor/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.software.webview.xml:system/vendor/etc/permissions/android.software.webview.xml \
    frameworks/native/data/etc/android.software.voice_recognizers.xml:system/vendor/etc/permissions/android.software.voice_recognizers.xml

# Motorola-specific permissions
PRODUCT_COPY_FILES += \
    device/motorola/quark/permissions/com.motorola.actions.xml:system/vendor/etc/permissions/com.motorola.actions.xml \
    device/motorola/quark/permissions/com.motorola.android.dm.service.xml:system/vendor/etc/permissions/com.motorola.android.dm.service.xml \
    device/motorola/quark/permissions/com.motorola.android.encryption_library.xml:system/vendor/etc/permissions/com.motorola.android.encryption_library.xml \
    device/motorola/quark/permissions/com.motorola.android.settings.shared.xml:system/vendor/etc/permissions/com.motorola.android.settings.shared.xml \
	device/motorola/quark/permissions/com.motorola.android.tcmd.xml:system/vendor/etc/permissions/com.motorola.android.tcmd.xml \
    device/motorola/quark/permissions/com.motorola.aon.quickpeek.xml:system/vendor/etc/permissions/com.motorola.aon.quickpeek.xml \
    device/motorola/quark/permissions/com.motorola.aov.xml:system/vendor/etc/permissions/com.motorola.aov.xml \
    device/motorola/quark/permissions/com.motorola.camera.xml:system/vendor/etc/permissions/com.motorola.camera.xml \
    device/motorola/quark/permissions/com.motorola.camerabgproc_library.xml:system/vendor/etc/permissions/com.motorola.camerabgproc_library.xml \
	device/motorola/quark/permissions/com.motorola.commandcenter.library.xml:system/vendor/etc/permissions/com.motorola.commandcenter.library.xml \
	device/motorola/quark/permissions/com.motorola.device.xml:system/vendor/etc/permissions/com.motorola.device.xml \
	device/motorola/quark/permissions/com.motorola.email.xml:system/vendor/etc/permissions/com.motorola.email.xml \
    device/motorola/quark/permissions/com.motorola.frameworks.core.addon.xml:system/vendor/etc/permissions/com.motorola.frameworks.core.addon.xml \
    device/motorola/quark/permissions/com.motorola.gallery.xml:system/vendor/etc/permissions/com.motorola.gallery.xml \
    device/motorola/quark/permissions/com.motorola.haptic.xml:system/vendor/etc/permissions/com.motorola.haptic.xml \
	device/motorola/quark/permissions/com.motorola.moto.xml:system/vendor/etc/permissions/com.motorola.moto.xml \
    device/motorola/quark/permissions/com.motorola.motodisplay.pd.screenoff.xml:system/vendor/etc/permissions/com.motorola.motodisplay.pd.screenoff.xml \
    device/motorola/quark/permissions/com.motorola.motosignature.xml:system/vendor/etc/permissions/com.motorola.motosignature.xml \
	device/motorola/quark/permissions/com.motorola.sensorhub.stm401.xml:system/vendor/etc/permissions/com.motorola.sensorhub.stm401.xml \
    device/motorola/quark/permissions/com.motorola.slpc.xml:system/vendor/etc/permissions/com.motorola.slpc.xml \
    device/motorola/quark/permissions/com.motorola.software.bodyguard.xml:system/vendor/etc/permissions/com.motorola.software.bodyguard.xml \
    device/motorola/quark/permissions/com.motorola.software.droid_line.xml:system/vendor/etc/permissions/com.motorola.software.droid_line.xml \
    device/motorola/quark/permissions/com.motorola.software.folio.xml:system/vendor/etc/permissions/com.motorola.software.folio.xml \
	device/motorola/quark/permissions/com.motorola.software.guideme.xml:system/vendor/etc/permissions/com.motorola.software.guideme.xml \
    device/motorola/quark/permissions/com.motorola.software.smartnotifications.xml:system/vendor/etc/permissions/com.motorola.software.smartnotifications.xml \
    device/motorola/quark/permissions/com.motorola.targetnotif.xml:system/vendor/etc/permissions/com.motorola.targetnotif.xml \
    device/motorola/quark/permissions/com.motorola.zap.xml:system/vendor/etc/permissions/com.motorola.zap.xml

#$(call inherit-product, frameworks/native/build/phone-xhdpi-2048-dalvik-heap.mk)

PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapstartsize=8m \
    dalvik.vm.heapgrowthlimit=256m \
    dalvik.vm.heapsize=512m \
    dalvik.vm.heaptargetutilization=0.75 \
    dalvik.vm.heapminfree=2m \
    dalvik.vm.heapmaxfree=8m

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
    tinymix

PRODUCT_PACKAGES += \
    mbhc.bin \
    wcd9310_anc.bin

# Art
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dex2oat-swap=false

# Audio configuration
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    $(LOCAL_PATH)/audio/audio_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_platform_info.xml \
    $(LOCAL_PATH)/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(LOCAL_PATH)/audio/audio_policy_volumes_drc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes_drc.xml \
    $(LOCAL_PATH)/audio/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml \
    $(LOCAL_PATH)/audio/motvr_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/motvr_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml

# Camera
PRODUCT_PACKAGES += \
    camera.apq8084

# Charger
PRODUCT_PACKAGES += \
    charger \
    charger_res_images

# LineageActions
PRODUCT_PACKAGES += \
    LineageActions \
    libjni_LineageActions

# CNE
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/andsfCne.xml:system/etc/cne/andsfCne.xml \
    $(LOCAL_PATH)/configs/SwimConfig.xml:system/etc/cne/SwimConfig.xml

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

# Display
PRODUCT_PACKAGES += \
    copybit.apq8084 \
    gralloc.apq8084 \
    hwcomposer.apq8084 \
    libgenlock \
    memtrack.apq8084 \
    hdmi_cec.apq8084

# IDC
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/idc/atmel_mxt_ts.idc:system/usr/idc/atmel_mxt_ts.idc

# IPv6 tethering
PRODUCT_PACKAGES += \
    ebtables \
    ethertypes \
    libqsap_sdk

# IRSC
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/sec_config:system/vendor/etc/sec_config

# Keylayout
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/keylayout/apq8084-taiko-tfa9890_stereo_co_Button_Jack.kl:system/usr/keylayout/apq8084-taiko-tfa9890_stereo_co_Button_Jack.kl \
    $(LOCAL_PATH)/keylayout/sensorprocessor.kl:system/usr/keylayout/sensorprocessor.kl \
    $(LOCAL_PATH)/keylayout/atmel_mxt_ts.kl:system/usr/keylayout/atmel_mxt_ts.kl

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
    frameworks/native/data/etc/android.hardware.nfc.xml:system/etc/permissions/android.hardware.nfc.xml \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:system/etc/permissions/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.hcef.xml:system/etc/permissions/android.hardware.nfc.hcef.xml \
    $(LOCAL_PATH)/configs/nfcee_access.xml:system/etc/nfcee_access.xml \
    $(LOCAL_PATH)/configs/libnfc-brcm.conf:system/vendor/etc/libnfc-brcm.conf \
    $(LOCAL_PATH)/configs/libnfc-brcm-20795a10.conf:system/vendor/etc/libnfc-brcm-20795a10.conf

# OMX
PRODUCT_PACKAGES += \
    libc2dcolorconvert \
    libdivxdrmdecrypt \
    libextmedia_jni \
    libOmxAacEnc \
    libOmxAmrEnc \
    libOmxCore \
    libOmxEvrcEnc \
    libOmxQcelp13Enc \
    libOmxVdec \
    libOmxVenc \
    libOmxVdpp \
    libOmxVidcCommon \
    libstagefrighthw

# Ramdisk
PRODUCT_PACKAGES += \
    fstab.qcom \
    init.mmi.boot.sh \
    init.mmi.touch.sh \
    init.mmi.usb.sh \
    init.qcom.rc \
    init.qcom.power.rc \
    init.qcom.wifi.sh \
    init.qcom.usb.rc \
    init.recovery.qcom.rc \
    init.mmi.volte.rc \
    post_init_rr.sh \
    ueventd.qcom.rc \
    post_init_rr_bootc.sh

# RIL
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/dsi_config.xml:system/etc/data/dsi_config.xml \
    $(LOCAL_PATH)/configs/netmgr_config.xml:system/etc/data/netmgr_config.xml \
    $(LOCAL_PATH)/configs/qcril.db:system/etc/motorola/qcril.db \
    $(LOCAL_PATH)/configs/qmi_config.xml:system/etc/data/qmi_config.xml

PRODUCT_PACKAGES += \
    librmnetctl

# Support
PRODUCT_PACKAGES += \
    libcurl \
    libxml2

# Thermal
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/thermal-engine-quark.conf:system/vendor/etc/thermal-engine-quark.conf

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
    $(LOCAL_PATH)/configs/hostapd.accept:system/etc/hostapd/hostapd.accept \
    $(LOCAL_PATH)/configs/hostapd.deny:system/etc/hostapd/hostapd.deny \
    $(LOCAL_PATH)/configs/hostapd_default.conf:system/etc/hostapd/hostapd_default.conf

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/p2p_supplicant_overlay.conf:system/etc/wifi/p2p_supplicant_overlay.conf \
    $(LOCAL_PATH)/configs/wpa_supplicant_overlay.conf:system/etc/wifi/wpa_supplicant_overlay.conf

PRODUCT_COPY_FILES += \
    kernel/motorola/apq8084/drivers/staging/qcacld-2.0/firmware_bin/WCNSS_cfg.dat:system/vendor/firmware/WCNSS_cfg.dat \
    kernel/motorola/apq8084/drivers/staging/qcacld-2.0/firmware_bin/WCNSS_qcom_cfg.ini:system/vendor/firmware/WCNSS_qcom_cfg.ini \
    kernel/motorola/apq8084/drivers/staging/qcacld-2.0/firmware_bin/WCNSS_qcom_wlan_nv.bin:system/vendor/firmware/WCNSS_qcom_wlan_nv.bin

# Sensors
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/sensors/_hals.conf:system/vendor/etc/sensors/_hals.conf

PRODUCT_PACKAGES += \
    sensors.apq8084

# shims
PRODUCT_PACKAGES += \
    libshims_thermal \
    libshim_qcopt

# ro.product.first_api_level indicates the first api level the device has commercially launched on.
PRODUCT_PROPERTY_OVERRIDES += \
    ro.product.first_api_level=19

# low audio flinger standby delay to reduce power consumption
PRODUCT_PROPERTY_OVERRIDES += \
    ro.audio.flinger_standbytime_ms=300

#android_filesystem_config.h
PRODUCT_PACKAGES += \
    fs_config_files

# Treble packages
$(call inherit-product, device/motorola/quark/treble.mk)
