DFILES := $(shell find . -type f -name "*.df")
OBJ    := $(DFILES:.df=.o)

DC      = ../../../sdk/dragonc.sh
AS      = ../../../sdk/asm.sh
OBJTOOL = ../../../sdk/link.sh
LD      =  $(OBJTOOL) link

all: sh.LOFF

sh.LOFF: $(OBJ)
	$(LD) sh.LOFF $(OBJ) L/rtaisix/rtaisix.o
	$(OBJTOOL) move sh.LOFF aisix

%.o: %.df
	$(DC) $< $@

cleanup:
	rm -f *.o *.bin *.LOFF
