DFILES := $(shell find . -type f -name '*.df')
OBJ    := $(DFILES:.df=.o)

DC      =  ../../../../sdk/dragonc.sh
AS      = ../../../../sdk/asm.sh
OBJTOOL = ../../../../sdk/link.sh
LD      =  $(OBJTOOL) link

all: aisix.image

aisix.image: aisix.bin ../services/boot/bootimage.tar
	cat aisix.bin ../services/boot/bootimage.tar > aisix.image

aisix.bin: $(OBJ) start.o end.o
	$(LD) aisix.bin start.o $(OBJ) L/libsa/lib.o L/liba3x/lib.o end.o
	$(OBJTOOL) flatten aisix.bin 0x80000

start.o: start.s
	$(AS) start.s start.o

end.o: end.s
	$(AS) end.s end.o

%.o: %.df
	$(DC) incdir=./include/ $< $@

cleanup:
	rm ${OBJ} aisix.bin aisix.image