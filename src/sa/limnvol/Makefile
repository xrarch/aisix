DFILES := $(shell find . -type f -name "*.df")
OBJ    := $(DFILES:.df=.o)

DC      =  ../../../../sdk/dragonc.sh
OBJTOOL = ../../../../sdk/link.sh
LD      =  $(OBJTOOL) link

all: limnvol.a3x

limnvol.a3x: $(OBJ)
	$(LD) limnvol.a3x L/rta3x/_boot.o $(OBJ) L/rta3x/rta3x.o
	$(OBJTOOL) move limnvol.a3x text=0x80000,data=text+text_size,bss=data+data_size
	$(OBJTOOL) binary limnvol.a3x

%.o: %.df
	$(DC) $< $@

cleanup:
	rm -f ${OBJ} *.bin *.LOFF *.a3x
