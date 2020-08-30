DFILES := $(shell find . -type f -name "*.df")
OBJ    := $(DFILES:.df=.o)

DC      = ../../../sdk/dragonc.sh
AS      = ../../../sdk/asm.sh
OBJTOOL = ../../../sdk/link.sh
LD      =  $(OBJTOOL) link

all: init.LOFF

init.LOFF: $(OBJ)
	$(LD) init.LOFF $(OBJ) L/rtaisix/rtaisix.o
	$(OBJTOOL) move init.LOFF aisix
	$(OBJTOOL) strip init.LOFF

%.o: %.df
	$(DC) $< $@

cleanup:
	rm -f *.o *.bin *.LOFF
