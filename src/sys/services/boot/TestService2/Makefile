DFILES := $(shell find . -type f -name '*.df')
OBJ    := $(DFILES:.df=.o)

DC      =  ../../../../../../sdk/dragonc.sh
AS      = ../../../../../../sdk/asm.sh
OBJTOOL = ../../../../../../sdk/link.sh
LD      =  $(OBJTOOL) link

all: TestService2

TestService2: $(OBJ)
	$(LD) TestService2 $(OBJ) L/generic/lib.o L/aisix/lib.o

	-gtar -f ../bootimage.tar --delete $@
	gtar --format=ustar --blocking-factor=1 -rf ../bootimage.tar $@

	cp TestService2 TestService
	gtar --format=ustar --blocking-factor=1 -rf ../bootimage.tar TestService

%.o: %.df
	$(DC) $< $@

cleanup:
	rm *.o
	rm *.boot