DFILES := $(shell find . -type f -name "*.df")
OBJ    := $(DFILES:.df=.o)

DC      =  ../../../../sdk/dragonc.sh
OBJTOOL = ../../../../sdk/link.sh
LD      =  $(OBJTOOL) link

all: diag.a3x

diag.a3x: $(OBJ)
	$(LD) diag.a3x LX/xr17032/rta3x/_boot.o $(OBJ) L/rta3x/rta3x.o
	$(OBJTOOL) move diag.a3x text=0x30000,data=text+text_size,bss=data+data_size
	$(OBJTOOL) binary diag.a3x

%.o: %.df
	$(DC) $< $@

cleanup:
	rm -f ${OBJ} *.bin *.LOFF *.a3x
