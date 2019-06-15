InterruptDisable:
	pushv r5, rs
	bclri rs, rs, 1
	ret

InterruptEnable:
	pushv r5, rs
	bseti rs, rs, 1
	ret

InterruptRestore:
	popv r5, rs
	ret

InterruptGet:
	rsh r0, rs, 1
	andi r0, r0, 1
	pushv r5, r0
	ret

cpu_interrupt_throwaway:
	cli
	ret