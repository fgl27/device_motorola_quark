$(call inherit-product, device/motorola/quark/full_quark.mk)

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Enhanced NFC
$(call inherit-product, vendor/cm/config/nfc_enhanced.mk)

PRODUCT_RELEASE_NAME := Moto MAXX
PRODUCT_NAME := cm_quark

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=quark \
    BUILD_FINGERPRINT=motorola/quark_retbr/quark_umts:5.0.2/LXG22.33-12.13/13:user/release-keys\
    PRIVATE_BUILD_DESC="quark_retbr-user 5.0.2 LXG22.33-12.13 13 release-keys"
