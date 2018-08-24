# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common CM stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit from quark device
$(call inherit-product, device/motorola/quark/device.mk)
$(call inherit-product, vendor/motorola/quark/quark-vendor.mk)

# Overlay
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay \
    $(LOCAL_PATH)/overlay-lineage

# Device identifier. This must come after all inclusions
PRODUCT_RELEASE_NAME := Moto MAXX
PRODUCT_NAME := lineage_quark
PRODUCT_DEVICE := quark
PRODUCT_BRAND := motorola
PRODUCT_MODEL := quark
PRODUCT_MANUFACTURER := motorola

TARGET_VENDOR := motorola

PRODUCT_GMS_CLIENTID_BASE := android-motorola

PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_BUILD_FLAVOR=quark-$(TARGET_BUILD_VARIANT)
