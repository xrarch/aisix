DFILES := $(shell find . -type f -name '*.df')
OBJ    := $(DFILES:.df=.o)

DC      =  ../../../../../sdk/dragonc.sh
OBJTOOL = ../../../../../sdk/link.sh
LD      =  $(OBJTOOL) link

all: diag.a3x

diag.a3x: $(OBJ)
	$(LD) diag.a3x L/libsa/_i6l_start.o $(OBJ) L/libsa/lib.o L/liba3x/lib.o
	$(OBJTOOL) flatten diag.a3x 0x80000

%.o: %.df
	$(DC) $< $@

cleanup:
	rm *.o *.a3x