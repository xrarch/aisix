asm preamble "

.org 0x200000

.ds VNIX

KernelEntry:

cli ;clear pending interrupts
li rs, 0x80000000 ;reset ebus
cli ;clear pending interrupts again
li r5, 0x200000
li sp, 0x1FE000
li ivt, 0 ;reset ivt
cli ;clear them even more

;r2 contains args
pushv r5, r2

;r3 contains image size
pushv r5, r3

b Main

ResetSystem:
	lri.l r0, 0xFFFE0000
	br r0

"