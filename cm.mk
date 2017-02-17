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

ifneq ($(CM_DISPLAY_VERSION),)
PRODUCT_BUILD_PROP_OVERRIDES += \
    BUILD_DISPLAY_ID=$(CM_DISPLAY_VERSION)
else
ifneq ($(LINEAGE_VERSION),)
PRODUCT_BUILD_PROP_OVERRIDES += \
    BUILD_DISPLAY_ID=$(LINEAGE_VERSION)
endif
endif
