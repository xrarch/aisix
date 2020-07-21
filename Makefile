FLATIMAGE  := no

DISTIMAGE  := ./dist/dist.img
DISTIMGSZ  := 256
FSTOOL     := ../sdk/fstool.sh

PLATFORM   := limnstation
CPU        := limn2k

ifeq ($(FLATIMAGE),no)
	DISKLABEL  := ./dist/preset.disklabel
	OFFSET     := 2
else
	OFFSET     := 0
endif

FILELOADER_DIR := ./src/stand/fileloader
DIAG_DIR       := ./src/stand/diag
LIMNVOL_DIR    := ./src/stand/limnvol
KERNEL_DIR     := ./src/sys/kernel

dist: $(DISTIMAGE) bootable stand kernel

kernel:
	make --directory=$(KERNEL_DIR) PLATFORM=$(PLATFORM) CPU=$(CPU)
	$(FSTOOL) $(DISTIMAGE) offset=$(OFFSET) w /kernel $(KERNEL_DIR)/aisix.a3x

stand: diag limnvol

diag:
	make --directory=$(DIAG_DIR)
	$(FSTOOL) $(DISTIMAGE) offset=$(OFFSET) w /stand/diag $(DIAG_DIR)/diag.a3x

limnvol:
	make --directory=$(LIMNVOL_DIR)
	$(FSTOOL) $(DISTIMAGE) offset=$(OFFSET) w /stand/limnvol $(LIMNVOL_DIR)/limnvol.a3x

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

	$(FSTOOL) $(DISTIMAGE) offset=$(OFFSET) f

cleanup:
	rm -f $(DISTIMAGE)
	make -C src/stand cleanup
	make -C $(KERNEL_DIR) cleanup
