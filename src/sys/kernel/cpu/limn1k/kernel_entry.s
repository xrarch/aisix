;routines related to kernel entry via a trap

kernel_entry:
	pop k3
	push k3
	push usp
	pusha

	andi k3, k3, 1
	cmpi k3, 0
	be .kmode

	;only load new r5 if going from user mode to kernel mode
	;if already in kernel mode, continue to use the current process's r5

	;lri.l r5, ProcCurrentkr5
	;addi r5, r5, 1024

	li r5, 0x200000

.kmode:
	pushv r5, sp

	call cpu_trap

	popa
	pop usp
	iret

.wt:
	br r1
	ret