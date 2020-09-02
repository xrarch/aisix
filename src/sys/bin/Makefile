DFILES := $(shell find . -type f -name "*.df")
OBJ    := $(DFILES:.df=.o)
LOFF   := $(OBJ:.o=.LOFF)

DC      = ../../../../sdk/dragonc.sh
AS      = ../../../../sdk/asm.sh
OBJTOOL = ../../../../sdk/link.sh
LD      =  $(OBJTOOL) link

all: $(LOFF)

.PRECIOUS: %.o

%.LOFF: %.o
	$(LD) $@ $< L/rtaisix/rtaisix.o
	$(OBJTOOL) move $@ aisix
	$(OBJTOOL) strip $@

%.o: %.df
	$(DC) $< $@