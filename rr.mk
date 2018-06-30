$(call inherit-product, device/motorola/quark/full_quark.mk)

# Inherit some common CM stuff.
$(call inherit-product, vendor/rr/config/common_full_phone.mk)

# Overlay
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay \
    $(LOCAL_PATH)/overlay-rr

PRODUCT_RELEASE_NAME := Moto MAXX
PRODUCT_NAME := rr_quark

PRODUCT_GMS_CLIENTID_BASE := android-motorola

PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_BUILD_FLAVOR=quark-$(TARGET_BUILD_VARIANT)

# export the below before . build/envsetup.sh
# export ROM_VVV=$(grep PRODUCT_VERSION vendor/rr/config/common.mk | head -1 | awk '{print $3}');
#This will make TWRP backups name same as ROM zip name
PRODUCT_BUILD_PROP_OVERRIDES += \
    BUILD_DISPLAY_ID=RR-O-v$(ROM_VVV)-$(shell date -u +%Y%m%d)-quark-$(RR_BUILDTYPE)
