DFILES := $(shell find . -type f -name '*.d')
OBJ    := $(DFILES:.d=.o)

DC      =  ../../../../../sdk/dragonc.sh
OBJTOOL = ../../../../../sdk/link.sh
LD      =  $(OBJTOOL) link

all: diag.a3x

diag.a3x: $(OBJ)
	$(LD) diag.a3x L/a3x/_start.o $(OBJ) L/generic/lib.o L/a3x/lib.o
	$(OBJTOOL) flatten diag.a3x 0x200000

%.o: %.d
	$(DC) $< $@

cleanup:
	rm *.o *.a3x