DFILES := $(shell find . -type f -name "*.df")
OBJ    := $(DFILES:.df=.o)

DC      = ../../../../sdk/dragonc.sh
AS      = ../../../../sdk/asm.sh
OBJTOOL = ../../../../sdk/link.sh
LD      =  $(OBJTOOL) link

all: sash.a3x BootSector.bin

BootSector.bin: BootSector.s
	$(AS) format=flat BootSector.s BootSector.bin

sash.a3x: $(OBJ)
	$(LD) sash.a3x LX/xr17032/rta3x/_boot.o $(OBJ) L/rta3x/rta3x.o
	$(OBJTOOL) move sash.a3x text=0x20000,data=text+text_size,bss=data+data_size
	cp sash.a3x sash.LOFF
	$(OBJTOOL) binary sash.a3x

%.o: %.df
	$(DC) $< $@

cleanup:
	rm -f ${OBJ} *.bin *.LOFF *.a3x
