DFILES := $(shell find . -type f -name '*.df')
OBJ    := $(DFILES:.df=.o)

DC      =  ../../../../../../sdk/dragonc.sh
AS      = ../../../../../../sdk/asm.sh
OBJTOOL = ../../../../../../sdk/link.sh
LD      =  $(OBJTOOL) link

all: ../Test.i6s

../Test.i6s: $(OBJ) ../../libservice/libservice.o
	$(LD) ../Test.i6s $(OBJ) L/libsa/lib.o L/libaisix/lib.o ../../libservice/libservice.o #FIXME

%.o: %.df
	$(DC) $< $@

cleanup:
	rm *.o