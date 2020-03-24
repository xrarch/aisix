DFILES := $(shell find . -type f -name '*.df')
OBJ    := $(DFILES:.df=.o)

DC      =  ../../../../../sdk/dragonc.sh
AS      = ../../../../../sdk/asm.sh
OBJTOOL = ../../../../../sdk/link.sh
LD      =  $(OBJTOOL) link

all: libservice.o

libservice.o: $(OBJ)
	$(LD) -f libservice.o $(OBJ)

%.o: %.df
	$(DC) $< $@

cleanup:
	rm *.o