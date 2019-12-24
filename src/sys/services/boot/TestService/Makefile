DFILES := $(shell find . -type f -name '*.df')
OBJ    := $(DFILES:.df=.o)

DC      =  ../../../../../../sdk/dragonc.sh
AS      = ../../../../../../sdk/asm.sh
OBJTOOL = ../../../../../../sdk/link.sh
LD      =  $(OBJTOOL) link

all: TestService

TestService: $(OBJ)
	$(LD) TestService $(OBJ) L/generic/lib.o

	#-gtar -f ../bootimage.tar --delete $@
	#gtar --format=ustar --blocking-factor=1 -rf ../bootimage.tar $@

%.o: %.df
	$(DC) $< $@

cleanup:
	rm TestService
	rm *.o