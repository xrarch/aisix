DFILES := $(shell find . -type f -name '*.df')
OBJ    := $(DFILES:.df=.o)

DC      =  ../../../../sdk/dragonc.sh
AS      = ../../../../sdk/asm.sh
OBJTOOL = ../../../../sdk/link.sh
LD      =  $(OBJTOOL) link

all: aisix

aisix: $(OBJ) start.o
	$(LD) aisix.bin start.o $(OBJ) L/generic/lib.o L/a3x/lib.o
	$(OBJTOOL) flatten aisix.bin 0x80000

start.o: start.s
	$(AS) start.s start.o

%.o: %.df
	$(DC) incdir=./include/ $< $@

cleanup:
	rm *.o