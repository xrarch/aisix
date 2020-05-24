FLATIMAGE  := no

DISTIMAGE  := ./dist/dist.img
DISTIMGSZ  := 256
FSUTIL     := ../sdk/fsutil.sh

ifeq ($(FLATIMAGE),no)
	DISKLABEL  := ./dist/disklabel.bin
	OFFSET     := 2
else
	OFFSET     := 0
endif

FILELOADER_DIR := ./src/stand/fileloader
DIAG_DIR       := ./src/stand/diag
LIMNVOL_DIR    := ./src/stand/limnvol

dist: $(DISTIMAGE) bootable stand

stand: diag limnvol

diag:
	make --directory=$(DIAG_DIR)
	$(FSUTIL) $(DISTIMAGE) offset=$(OFFSET) w /stand/diag $(DIAG_DIR)/diag.a3x

limnvol:
	make --directory=$(LIMNVOL_DIR)
	$(FSUTIL) $(DISTIMAGE) offset=$(OFFSET) w /stand/limnvol $(LIMNVOL_DIR)/limnvol.a3x

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

	$(FSUTIL) $(DISTIMAGE) offset=$(OFFSET) f