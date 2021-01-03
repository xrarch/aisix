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

SASH_DIR       := src/sa/sash
DIAG_DIR       := src/sa/diag
LIMNVOL_DIR    := src/sa/limnvol
CMD_DIR        := src/bin
SYSBIN_DIR     := src/sys/bin
KERNEL_DIR     := src/sys/kernel

FSTOOL         := $(FST) $(DISTIMAGE) offset=$(OFFSET)

dist: $(DISTIMAGE) rtaisixt bootable stand kernel sysbin bin sysfiles

kernel:
	make --directory=$(KERNEL_DIR) PLATFORM=$(PLATFORM) CPU=$(CPU)
	$(FSTOOL) u /sys/aisix.A3X $(KERNEL_DIR)/aisix.a3x

bin:
ifeq ($(REBUILD_CMD),yes)
	rm -f $(CMD_DIR)/*.o
	rm -f $(CMD_DIR)/*.LOFF
endif
	make --directory=$(CMD_DIR)
	make writebin

writebin:
	$(foreach file, $(wildcard $(CMD_DIR)/*.LOFF), \
		$(FSTOOL) u /bin/$(shell basename -s .LOFF $(file)) $(file) ; \
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
		$(FSTOOL) u /sys/bin/$(shell basename -s .LOFF $(file)) $(file) ; \
		$(FSTOOL) chmod /sys/bin/$(shell basename -s .LOFF $(file)) 493 ;)

stand: diag limnvol

diag:
	make --directory=$(DIAG_DIR)
	$(FSTOOL) u /sa/diag.A3X $(DIAG_DIR)/diag.a3x

limnvol:
	make --directory=$(LIMNVOL_DIR)
	$(FSTOOL) u /sa/limnvol.A3X $(LIMNVOL_DIR)/limnvol.a3x

bootable:
	make --directory=$(SASH_DIR)
	dd if=$(SASH_DIR)/BootSector.bin of=$(DISTIMAGE) bs=4096 conv=notrunc seek=$$((1 + $(OFFSET))) 2>/dev/null
	dd if=$(SASH_DIR)/sash.a3x of=$(DISTIMAGE) bs=4096 conv=notrunc seek=$$((2 + $(OFFSET))) 2>/dev/null

sysfiles:
	$(FSTOOL) u /sys/motd.txt ./src/sys/motd.txt
	$(FSTOOL) u /sys/ttys.fields ./src/sys/ttys.fields
	$(FSTOOL) u /sys/user.fields ./src/sys/user.fields
	$(FSTOOL) u /sys/passwd.fields ./src/sys/passwd.fields
	$(FSTOOL) chmod /sys/passwd.fields 416
	$(FSTOOL) u /home/guest/README ./src/README
	$(FSTOOL) chown /home/guest 1
	$(FSTOOL) chown /home/guest/README 1

rtaisixt:
	./build-rtaisix.sh

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
	make -C rtaisix cleanup
	make -C src/sa cleanup
	make -C $(KERNEL_DIR) cleanup
	make -C $(CMD_DIR) cleanup
	make -C $(SYSBIN_DIR) cleanup
