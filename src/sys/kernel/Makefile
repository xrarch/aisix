PLATFORM := limnstation
CPU      := limn2600

PLATFORM_DIR := ../arch/$(PLATFORM)
CPU_DIR      := ../arch/$(CPU)

DFILES := $(shell find . -type f -name "*.df") $(shell find $(PLATFORM_DIR) -type f -name "*.df") $(shell find $(CPU_DIR) -type f -name "*.df")
SFILES := $(shell find $(PLATFORM_DIR) -type f -name "*.s") $(shell find $(CPU_DIR) -type f -name "*.s")
OBJ    := $(DFILES:.df=.o) $(SFILES:.s=.o)

DC      =  ../../../../sdk/dragonc.sh
AS      = ../../../../sdk/asm.sh
OBJTOOL = ../../../../sdk/link.sh
LD      =  $(OBJTOOL) link

DCFLAGS = incdir=./include/:$(PLATFORM_DIR)/include/:$(CPU_DIR)/include/

all: aisix.a3x

aisix.a3x: $(OBJ)
	$(LD) -f aisix.f.LOFF LX/limn2600/rta3x/_boot.o $(OBJ) L/rta3x/cia3x.o L/dfrt/dfrt.f.o
	$(OBJTOOL) symtab aisix.f.LOFF SYM.s_ 0x30000
	$(AS) SYM.s_ SYM.o
	$(LD) aisix.LOFF aisix.f.LOFF SYM.o
	$(OBJTOOL) move aisix.LOFF text=0x30000,data=text+text_size,bss=data+data_size
	cp aisix.LOFF aisix.a3x
	$(OBJTOOL) binary -nobss aisix.a3x

%.o: %.s
	$(AS) $< $@

%.o: %.df include/*.h $(PLATFORM_DIR)/include/*.h $(CPU_DIR)/include/*.h
	$(DC) $(DCFLAGS) $< $@

cleanup:
	rm -f ${OBJ} *.a3x *.LOFF
