FLATIMAGE  := no

DISTIMAGE  := ./dist/dist.img
DISTIMGSZ  := 256
FST        := ../sdk/fstool.sh

PLATFORM   := limnstation
CPU        := limn2k

ifeq ($(FLATIMAGE),no)
	DISKLABEL  := ./dist/preset.disklabel
	OFFSET     := 2
else
	OFFSET     := 0
endif

FILELOADER_DIR := src/stand/fileloader
DIAG_DIR       := src/stand/diag
LIMNVOL_DIR    := src/stand/limnvol
INIT_DIR       := src/init
SH_DIR         := src/sh
KERNEL_DIR     := src/sys/kernel

FSTOOL         := $(FST) $(DISTIMAGE) offset=$(OFFSET)

dist: $(DISTIMAGE) bootable stand kernel cmd

kernel:
	make --directory=$(KERNEL_DIR) PLATFORM=$(PLATFORM) CPU=$(CPU)
	$(FSTOOL) w /sys/aisix.A3X $(KERNEL_DIR)/aisix.a3x

cmd: init sh

init:
	rm -f $(INIT_DIR)/*.o
	make --directory=$(INIT_DIR)
	$(FSTOOL) w /sys/init.LOFF $(INIT_DIR)/init.LOFF
	$(FSTOOL) chmod /sys/init.LOFF 73

sh:
	rm -f $(SH_DIR)/*.o
	make --directory=$(SH_DIR)
	$(FSTOOL) w /cmd/sh.LOFF $(SH_DIR)/sh.LOFF
	$(FSTOOL) chmod /cmd/sh.LOFF 73

stand: diag limnvol

diag:
	make --directory=$(DIAG_DIR)
	$(FSTOOL) w /stand/diag.A3X $(DIAG_DIR)/diag.a3x

limnvol:
	make --directory=$(LIMNVOL_DIR)
	$(FSTOOL) w /stand/limnvol.A3X $(LIMNVOL_DIR)/limnvol.a3x

bootable:
	make --directory=$(FILELOADER_DIR)
	dd if=$(FILELOADER_DIR)/BootSector.bin of=$(DISTIMAGE) bs=4096 conv=notrunc seek=$$((1 + $(OFFSET))) 2>/dev/null
	dd if=$(FILELOADER_DIR)/loader.a3x of=$(DISTIMAGE) bs=4096 conv=notrunc seek=$$((2 + $(OFFSET))) 2>/dev/null

$(DISTIMAGE):
	dd if=/dev/zero of=$(DISTIMAGE) bs=4096 count=$(DISTIMGSZ) 2>/dev/null

ifeq ($(FLATIMAGE),no)
ifneq ($(DISKLABEL),none)
		dd if=$(DISKLABEL) of=$(DISTIMAGE) bs=4096 count=1 seek=0 conv=notrunc
endif
endif

	$(FSTOOL) f
	$(FSTOOL) w /dev/ph.txt ./ph.txt
	$(FSTOOL) d /dev/ph.txt

cleanup:
	rm -f $(DISTIMAGE)
	make -C src/stand cleanup
	make -C $(KERNEL_DIR) cleanup
	make -C $(SH_DIR) cleanup
	make -C $(INIT_DIR) cleanup
