DFILES := $(shell find . -type f -name '*.d')
OBJ    := $(DFILES:.d=.o)

DC      =  ../../../../../sdk/dragonc.sh
OBJTOOL = ../../../../../sdk/link.sh
LD      =  $(OBJTOOL) link

all: dskfa.a3x

dskfa.a3x: $(OBJ)
	$(LD) dskfa.a3x L/a3x/_start.o $(OBJ) L/generic/lib.o L/a3x/lib.o
	$(OBJTOOL) flatten dskfa.a3x 0x80000

%.o: %.d
	$(DC) $< $@

cleanup:
	rm *.o *.a3x