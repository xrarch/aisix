DFILES := $(shell find . -type f -name '*.df')
OBJ    := $(DFILES:.df=.o)

DC      =  ../../../../sdk/dragonc.sh
AS      = ../../../../sdk/asm.sh
OBJTOOL = ../../../../sdk/link.sh
LD      =  $(OBJTOOL) link

all: aisix.image

aisix.image: aisix.bin ../services/boot/bootimage.tar
	cat aisix.bin ../services/boot/bootimage.tar > aisix.image

aisix.bin: $(OBJ) end.o
	$(LD) aisix.bin L/rta3x/_boot.o $(OBJ) L/rta3x/rta3x.o end.o
	$(OBJTOOL) flatten aisix.bin 0x80000

end.o: end.s
	$(AS) end.s end.o

%.o: %.df
	$(DC) incdir=./include/ $< $@

cleanup:
	rm ${OBJ} aisix.bin aisix.image end.o