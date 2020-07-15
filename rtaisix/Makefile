DFILES := $(shell find ./src -type f -name "*.df")
SFILES := $(shell find ./src -type f -name "*.s")
OBJ    := $(DFILES:.df=.o)
SOBJ   := $(SFILES:.s=.o)

DC  =  ../../sdk/dragonc.sh
AS  =  ../../sdk/asm.sh
LD  =  ../../sdk/link.sh link

all: obj/rtaisix.o

obj/rtaisix.o: $(OBJ) $(SOBJ)
	$(LD) -f obj/rtaisix.o L/dfrt/dfrt.f.o $(OBJ) $(SOBJ)

%.o: %.df
	$(DC) $< $@ incdir=./headers/

%.o: %.s
	$(AS) $< $@

cleanup:
	rm $(OBJ) $(SOBJ) obj/rtaisix.o