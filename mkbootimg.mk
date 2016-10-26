LOCAL_PATH := $(call my-dir)

## Build and run dtbtool
DTBTOOL := $(HOST_OUT_EXECUTABLES)/dtbToolCM$(HOST_EXECUTABLE_SUFFIX)
INSTALLED_DTIMAGE_TARGET := $(PRODUCT_OUT)/dt.img
RAW_DTIMAGE_TARGET := $(PRODUCT_OUT)/dt.raw

$(RAW_DTIMAGE_TARGET): $(DTBTOOL) $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr $(INSTALLED_KERNEL_TARGET)
	@echo "Start DT image: $@"
	$(call append-cm-dtb)
	$(call pretty,"Target raw dt image: $(RAW_DTIMAGE_TARGET)")
	$(hide) $(DTBTOOL) -2 -o $(RAW_DTIMAGE_TARGET) -s $(BOARD_KERNEL_PAGESIZE) -p $(KERNEL_OUT)/scripts/dtc/ $(KERNEL_OUT)/arch/arm/boot/dts/
	@echo "Made DT image: $@"

$(INSTALLED_DTIMAGE_TARGET): $(RAW_DTIMAGE_TARGET)
	$(call pretty,"Target dt image: $(INSTALLED_DTIMAGE_TARGET)")
	lz4 -9 < $(RAW_DTIMAGE_TARGET) > $@ || lz4c -c1 -y $(RAW_DTIMAGE_TARGET) $@

## Overload bootimg generation: Same as the original, + --dt arg
$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES) $(INSTALLED_DTIMAGE_TARGET)
	$(call pretty,"Target boot image: $@")
	$(hide) $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --dt $(INSTALLED_DTIMAGE_TARGET) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE),raw)
	@echo "Made boot image: $@"

## Overload recoveryimg generation: Same as the original, + --dt arg
$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) $(INSTALLED_DTIMAGE_TARGET) $(recovery_ramdisk) $(recovery_kernel)
	@echo "----- Making recovery image ------"
	$(hide) $(MKBOOTIMG) $(INTERNAL_RECOVERYIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --dt $(INSTALLED_DTIMAGE_TARGET) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)
	@echo "Made recovery image: $@"
