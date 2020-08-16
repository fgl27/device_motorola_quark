
# Art
#$(call inherit-product, frameworks/native/build/phone-xhdpi-2048-dalvik-heap.mk)
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapstartsize=16m \
    dalvik.vm.heapgrowthlimit=256m \
    dalvik.vm.heapsize=512m \
    dalvik.vm.heaptargetutilization=0.75 \
    dalvik.vm.heapminfree=2m \
    dalvik.vm.heapmaxfree=8m \
    dalvik.vm.dex2oat-swap=false

# Audio
##fluencetype can be "fluence" or "fluencepro" or "none"
PRODUCT_PROPERTY_OVERRIDES += \
    ro.audio.flinger_standbytime_ms=300
    ro.vendor.audio.sdk.fluencetype=none \
    persist.vendor.audio.fluence.voicecall=true \
    persist.vendor.audio.fluence.voicerec=false \
    persist.vendor.audio.fluence.speaker=true \
    use.voice.path.for.pcm.voip=false \
    use.dedicated.device.for.voip=false \
    af.fast_track_multiplier=1 \
    vendor.audio_hal.period_size=192

# Bluetooth
PRODUCT_PROPERTY_OVERRIDES += \
    bt.max.hfpclient.connections=1 \
    vendor.qcom.bluetooth.soc=rome \
    qcom.bt.le_dev_pwr_class=1 \
    ro.bluetooth.hfp.ver=1.6 \
    ro.qualcomm.bluetooth.sap=false

# Camera
PRODUCT_PROPERTY_OVERRIDES += camera2.portability.force_api=1

# Data Disable mobile data by default
PRODUCT_PROPERTY_OVERRIDES += ro.com.android.mobiledata=false

# Disable more Codec2.0 components
PRODUCT_PROPERTY_OVERRIDES += debug.stagefright.ccodec=0

# Display
PRODUCT_PROPERTY_OVERRIDES += \
    ro.qualcomm.cabl=0 \
    ro.opengles.version=196610 \
    ro.sf.lcd_density=560 \
    debug.hwui.use_buffer_age=false \
    debug.hwui.renderer=opengl \
    mm.enable.sec.smoothstreaming=true \
    mm.enable.qcom_parser=3183219 \
    persist.mm.enable.prefetch=true \
    debug.sf.enable_gl_backpressure=1 \
    debug.sf.disable_backpressure=1 \
    debug.sf.latch_unsignaled=1

# FRP
PRODUCT_PROPERTY_OVERRIDES +=ro.frp.pst=/dev/block/platform/msm_sdcc.1/by-name/frp

# GLES doesn't support secure display, to allow google play movies
# and other apps that require a secure display we need to enable this:
PRODUCT_PROPERTY_OVERRIDES += \
    persist.hwc.mdpcomp.enable=false \
    debug.mdpcomp.logs=0

# GPS
PRODUCT_PROPERTY_OVERRIDES += \
    persist.gps.qc_nlp_in_use=0 \
    ro.gps.agps_provider=1 \
    ro.qc.sdk.izat.premium.enabled=0 \
    ro.qc.sdk.izat.service_mask=0x0

# Gps Smart Battery Savings (depends on sensor hub)
PRODUCT_PROPERTY_OVERRIDES += persist.mot.gps.smart_battery=1

# Media
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.audio.offload.buffer.size.kb=32 \
    audio.offload.disable=0 \
    av.offload.enable=false \
    av.streaming.offload.enable=false \
    vendor.audio.offload.multiple.enabled=false \
    vendor.audio.offload.gapless.enabled=false \
    audio.offload.pcm.16bit.enable=false \
    audio.offload.pcm.24bit.enable=false \
    audio.deep_buffer.media=true \
    debug.stagefright.omx_default_rank.sw-audio=1 \
    debug.stagefright.omx_default_rank=0

# Memory optimizations
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.qti.sys.fw.bservice_enable=true

# NITZ
PRODUCT_PROPERTY_OVERRIDES += \
    rild.libpath=/system/vendor/lib/libril-qc-qmi-1.so \
    ril.subscription.types=NV,RUIM \
    DEVICE_PROVISIONED=1

# Play store
PRODUCT_PROPERTY_OVERRIDES += ro.com.google.clientidbase.gmm=android-motorola

# RmNet Data
PRODUCT_PROPERTY_OVERRIDES += \
    persist.rmnet.data.enable=true \
    persist.data.wda.enable=true \
    persist.data.df.dl_mode=5 \
    persist.data.df.ul_mode=5 \
    persist.data.df.agg.dl_pkt=10 \
    persist.data.df.agg.dl_size=4096 \
    persist.data.df.mux_count=8 \
    persist.data.df.iwlan_mux=9 \
    persist.data.df.dev_name=rmnet_usb0 \
    persist.data.llf.enable=true

# set module params for embedded rmnet devices
PRODUCT_PROPERTY_OVERRIDES += persist.rmnet.mux=enabled

# Qualcomm
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.extension_library=/system/vendor/lib/libqc-opt.so

# Radio
PRODUCT_PROPERTY_OVERRIDES += \
    persist.radio.no_wait_for_card=1 \
    persist.radio.apm_sim_not_pwdn=1 \
    persist.radio.apn_delay=5000 \
    persist.radio.dfr_mode_set=1 \
    persist.radio.relay_oprt_change=1 \
    persist.radio.msgtunnel.start=true \
    persist.radio.oem_ind_to_both=false \
    persist.data.netmgrd.qos.enable=true \
    persist.data.qmi.adb_logmask=0 \
    persist.radio.VT_USE_MDM_TIME=1 \
    ro.use_data_netmgrd=true \
    ro.data.large_tcp_window_size=true

# Reboot Shutdown timeout
PRODUCT_PROPERTY_OVERRIDES += ro.build.shutdown_timeout=7

# Enable UIM VCC feature
PRODUCT_PROPERTY_OVERRIDES += persist.qcril_uim_vcc_feature=1

# SSR
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.qc.sub.rdump.max=20 \
    persist.sys.qc.sub.rdump.on=1 \
    persist.sys.qc.sub.rstrtlvl=3 \
    persist.sys.ssr.restart_level=1

# Surfaceflinger
PRODUCT_PROPERTY_OVERRIDES += \
    ro.surface_flinger.force_hwc_copy_for_virtual_displays=true \
    ro.surface_flinger.max_frame_buffer_acquired_buffers=5

# Time
PRODUCT_PROPERTY_OVERRIDES += persist.timed.enable=true

# tethering Allow without provisioning app
PRODUCT_PROPERTY_OVERRIDES += net.tethering.noprovisioning=true

# USB
PRODUCT_PROPERTY_OVERRIDES += \
    ro.usb.mtp=2ea4 \
    ro.usb.mtp_adb=2ea5 \
    ro.usb.ptp=2ea6 \
    ro.usb.ptp_adb=2ea7 \
    ro.usb.bpt=2ea0 \
    ro.usb.bpt_adb=2ea1 \
    ro.usb.bpteth=2ea2 \
    ro.usb.bpteth_adb=2ea3 \
    ro.usb.mtp_cdrom=2ea8

# WLAN
PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=wlan0 \
    wlan.driver.ath=0 \
    wlan.driver.config=/data/misc/wifi/WCNSS_qcom_cfg.ini \
    ro.disableWifiApFirmwareReload=true

# ena root by default app only
PRODUCT_PROPERTY_OVERRIDES += persist.sys.root_access=1

# Set usb to adb and mtp
PRODUCT_PROPERTY_OVERRIDES += persist.sys.usb.config=mtp,adb

