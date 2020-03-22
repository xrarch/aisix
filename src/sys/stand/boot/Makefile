DFILES := $(shell find . -type f -name '*.df')
OBJ    := $(DFILES:.df=.o)

DC      =  ../../../../../sdk/dragonc.sh
AS      = ../../../../../sdk/asm.sh
OBJTOOL = ../../../../../sdk/link.sh
LD      =  $(OBJTOOL) link

all: loader.a3x BootSector.bin

BootSector.bin: BootSector.s
	$(AS) -flat BootSector.s BootSector.bin

loader.a3x: $(OBJ)
	$(LD) loader.a3x L/rta3x/_boot.o $(OBJ) L/rta3x/rta3x.o
	$(OBJTOOL) flatten loader.a3x 0x40000

%.o: %.df
	$(DC) $< $@

cleanup:
	rm *.o *.bin