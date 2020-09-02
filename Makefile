FLATIMAGE  := no

DISTIMAGE  := ./dist/dist.img
DISTIMGSZ  := 2048
FST        := ../sdk/fstool.sh

PLATFORM   := limnstation
CPU        := limn2k

ifeq ($(FLATIMAGE),no)
	DISKLABEL  := ./dist/preset.disklabel
	OFFSET     := 2
else
	OFFSET     := 0
endif

FILELOADER_DIR := src/sa/fileloader
DIAG_DIR       := src/sa/diag
LIMNVOL_DIR    := src/sa/limnvol
CMD_DIR        := src/bin
SYSBIN_DIR     := src/sys/bin
KERNEL_DIR     := src/sys/kernel

FSTOOL         := $(FST) $(DISTIMAGE) offset=$(OFFSET)

dist: $(DISTIMAGE) bootable stand kernel sysbin bin motd

kernel:
	make --directory=$(KERNEL_DIR) PLATFORM=$(PLATFORM) CPU=$(CPU)
	$(FSTOOL) w /sys/aisix.A3X $(KERNEL_DIR)/aisix.a3x

bin:
ifeq ($(REBUILD_CMD),yes)
	rm -f $(CMD_DIR)/*.o
	rm -f $(CMD_DIR)/*.LOFF
endif
	make --directory=$(CMD_DIR)
	make writebin

writebin:
	$(foreach file, $(wildcard $(CMD_DIR)/*.LOFF), \
		$(FSTOOL) w /bin/$(shell basename -s .LOFF $(file)) $(file) ; \
		$(FSTOOL) chmod /bin/$(shell basename -s .LOFF $(file)) 493 ;)

sysbin:
ifeq ($(REBUILD_CMD),yes)
	rm -f $(SYSBIN_DIR)/*.o
	rm -f $(SYSBIN_DIR)/*.LOFF
endif
	make --directory=$(SYSBIN_DIR)
	make writesys

writesys:
	$(foreach file, $(wildcard $(SYSBIN_DIR)/*.LOFF), \
		$(FSTOOL) w /sys/bin/$(shell basename -s .LOFF $(file)) $(file) ; \
		$(FSTOOL) chmod /sys/bin/$(shell basename -s .LOFF $(file)) 493 ;)

stand: diag limnvol

diag:
	make --directory=$(DIAG_DIR)
	$(FSTOOL) w /sa/diag.A3X $(DIAG_DIR)/diag.a3x

limnvol:
	make --directory=$(LIMNVOL_DIR)
	$(FSTOOL) w /sa/limnvol.A3X $(LIMNVOL_DIR)/limnvol.a3x

bootable:
	make --directory=$(FILELOADER_DIR)
	dd if=$(FILELOADER_DIR)/BootSector.bin of=$(DISTIMAGE) bs=4096 conv=notrunc seek=$$((1 + $(OFFSET))) 2>/dev/null
	dd if=$(FILELOADER_DIR)/loader.a3x of=$(DISTIMAGE) bs=4096 conv=notrunc seek=$$((2 + $(OFFSET))) 2>/dev/null

motd:
	$(FSTOOL) w /sys/motd.txt ./src/sys/motd.txt

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
