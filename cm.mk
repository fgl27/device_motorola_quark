$(call inherit-product, device/motorola/quark/full_quark.mk)

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Overlay
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

PRODUCT_RELEASE_NAME := Moto MAXX
PRODUCT_NAME := cm_quark

PRODUCT_GMS_CLIENTID_BASE := android-motorola

PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_BUILD_FLAVOR=quark-$(TARGET_BUILD_VARIANT)

ifneq ($(rom),)
ifeq ($(rom),r)
PRODUCT_BUILD_PROP_OVERRIDES += \
    BUILD_DISPLAY_ID=RR-N-v$(ROM_VVV)-$(shell date -u +%Y%m%d)-$(CM_BUILD)-$(RR_BUILDTYPE)
endif
ifeq ($(rom),c)
PRODUCT_BUILD_PROP_OVERRIDES += \
    BUILD_DISPLAY_ID=crDroidAndroid-7.1.1-$(shell date -u +%Y%m%d)-$(CM_BUILD)-v$(ROM_VVV)
endif
endif
