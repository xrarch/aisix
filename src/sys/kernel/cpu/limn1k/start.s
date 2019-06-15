;kernel entry for limn1k

;bootloader specific junk that probably shouldn't be here
.org 0x200000 ;vboot puts us at 0x200000

;vboot expects this signature in the kernel binary
.ds VNIX

limn1k_start:
	li ivt, 0 ;reset ivt
	li rs, 0x80000000 ;reset ebus
	cli ;clear interrupt queue
	li r5, 0x200000 ;set up initial dragonfruit stack
	li sp, 0x1FF000 ;set up initial kernel stack

	b platform_start_lowlevel