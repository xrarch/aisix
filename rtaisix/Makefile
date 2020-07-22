DFILES := $(shell find ./src -type f -name "*.df")
OBJ    := $(DFILES:.df=.o)

DC  =  ../../sdk/dragonc.sh
AS  =  ../../sdk/asm.sh
LD  =  ../../sdk/link.sh link

all: obj/rtaisix.o

obj/rtaisix.o: $(OBJ) _start.o end.o
	$(LD) -f obj/rtaisix.o L/dfrt/dfrt.f.o $(OBJ) ./src/_start.o ./src/end.o

%.o: %.df
	$(DC) $< $@ incdir=./headers/

%.o: %.s
	$(AS) $< $@

_start.o: ./src/_start.s
	$(AS) ./src/_start.s ./src/_start.o

end.o: ./src/end.s
	$(AS) ./src/end.s ./src/end.o

cleanup:
	rm $(OBJ) ./src/_start.o ./src/end.o obj/rtaisix.o