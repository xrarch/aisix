PLATFORM := limnstation
CPU      := limn2k

PLATFORM_DIR := ../arch/$(PLATFORM)
CPU_DIR      := ../arch/$(CPU)

DFILES := $(shell find . -type f -name "*.df") $(shell find $(PLATFORM_DIR) -type f -name "*.df") $(shell find $(CPU_DIR) -type f -name "*.df")
SFILES := $(shell find $(PLATFORM_DIR) -type f -name "*.s") $(shell find $(CPU_DIR) -type f -name "*.s")
OBJ    := $(DFILES:.df=.o) $(SFILES:.s=.o)

DC      =  ../../../../sdk/dragonc.sh
AS      = ../../../../sdk/asm.sh
OBJTOOL = ../../../../sdk/link.sh
LD      =  $(OBJTOOL) link

DCFLAGS = incdir=./include/:$(PLATFORM_DIR)/include/:$(CPU_DIR)/include/ target=$(CPU)

all: aisix.a3x

aisix.a3x: $(OBJ)
	$(LD) aisix.a3x L/rta3x/_boot.o $(OBJ) L/rta3x/cia3x.o L/dfrt/dfrt.f.o
	$(OBJTOOL) move aisix.a3x text=0x80000,data=text+text_size,bss=data+data_size
	cp aisix.a3x aisix.LOFF
	$(OBJTOOL) binary -nobss aisix.a3x

%.o: %.s
	$(AS) $< $@

%.o: %.df include/*.h $(PLATFORM_DIR)/include/*.h $(CPU_DIR)/include/*.h
	$(DC) $(DCFLAGS) $< $@

cleanup:
	rm ${OBJ} *.a3x *.LOFF