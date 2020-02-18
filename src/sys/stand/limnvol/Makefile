DFILES := $(shell find . -type f -name '*.df')
OBJ    := $(DFILES:.df=.o)

DC      =  ../../../../../sdk/dragonc.sh
OBJTOOL = ../../../../../sdk/link.sh
LD      =  $(OBJTOOL) link

all: limnvol.a3x

limnvol.a3x: $(OBJ)
	$(LD) limnvol.a3x L/libsa/_i6l_start.o $(OBJ) L/libsa/lib.o L/liba3x/lib.o
	$(OBJTOOL) flatten limnvol.a3x 0x80000

%.o: %.df
	$(DC) $< $@

cleanup:
	rm *.o *.a3x