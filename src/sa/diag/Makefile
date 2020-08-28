DFILES := $(shell find . -type f -name "*.df")
OBJ    := $(DFILES:.df=.o)

DC      =  ../../../../sdk/dragonc.sh
OBJTOOL = ../../../../sdk/link.sh
LD      =  $(OBJTOOL) link

all: diag.a3x

diag.a3x: $(OBJ)
	$(LD) diag.a3x L/rta3x/_boot.o $(OBJ) L/rta3x/rta3x.o
	$(OBJTOOL) binary diag.a3x 0x80000

%.o: %.df
	$(DC) $< $@

cleanup:
	rm -f *.o *.a3x
