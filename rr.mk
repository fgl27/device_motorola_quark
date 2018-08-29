$(call inherit-product, device/motorola/quark/device.mk)

DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay-rr

PRODUCT_NAME := rr_quark

# export the below before . build/envsetup.sh
# export ROM_VVV=$(grep PRODUCT_VERSION vendor/rr/config/common.mk | head -1 | awk '{print $3}');
#This will make TWRP backups name same as ROM zip name
PRODUCT_BUILD_PROP_OVERRIDES += \
    BUILD_DISPLAY_ID=RR-O-v$(ROM_VVV)-$(shell date -u +%Y%m%d)-quark-$(RR_BUILDTYPE)
