DFILES := $(shell find . -type f -name '*.df')
OBJ    := $(DFILES:.df=.o)

DC      =  ../../../../../sdk/dragonc.sh
AS      = ../../../../../sdk/asm.sh
OBJTOOL = ../../../../../sdk/link.sh
LD      =  $(OBJTOOL) link

all: loader.bin BootSector.bin

BootSector.bin: BootSector.s
	$(AS) -flat BootSector.s BootSector.bin

loader.bin: $(OBJ)
	$(LD) loader.bin L/liba3x/_boot.o $(OBJ) L/libsa/lib.o L/liba3x/lib.o
	$(OBJTOOL) flatten loader.bin 0x40000

%.o: %.df
	$(DC) $< $@

cleanup:
	rm *.o *.bin