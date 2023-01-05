DFILES := $(shell find ./src -type f -name "*.df")
OBJ    := $(DFILES:.df=.o)

DC  =  ../../sdk/dragonc.sh
AS  =  ../../sdk/asm.sh
LD  =  ../../sdk/link.sh link

all: obj/xr17032/rtaisix.o

obj/xr17032/rtaisix.o: $(OBJ) ./src/_start.o
	mkdir -p obj/xr17032
	$(LD) -f obj/xr17032/rtaisix.o $(OBJ) ./src/_start.o L/dfrt/dfrt.f.o

%.o: %.df
	$(DC) $< $@ incdir=./headers/

%.o: %.s
	$(AS) $< $@

./src/_start.o: ./src/_start.s
	$(AS) ./src/_start.s ./src/_start.o

cleanup:
	rm -f $(OBJ) ./src/_start.o obj/xr17032/rtaisix.o