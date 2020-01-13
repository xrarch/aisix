DFILES := $(shell find . -type f -name '*.df')
OBJ    := $(DFILES:.df=.o)

DC      =  ../../../../../../sdk/dragonc.sh
AS      = ../../../../../../sdk/asm.sh
OBJTOOL = ../../../../../../sdk/link.sh
LD      =  $(OBJTOOL) link

all: ../init.i6s

../init.i6s: $(OBJ) ../../libservice/libservice.o
	$(LD) ../init.i6s $(OBJ) L/generic/lib.o L/aisix/lib.o ../../libservice/libservice.o

%.o: %.df
	$(DC) $< $@

cleanup:
	rm *.o