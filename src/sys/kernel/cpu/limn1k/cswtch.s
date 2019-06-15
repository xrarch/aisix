;use old as pointer to place to save old context
;then switch to context in new
;new old --
swtch:
	popv r5, r0 ;r0 is old
	popv r5, r1 ;r1 is new

	push rs
	bclri rs, rs, 1
	pusha

	srr.l r0, sp ;save old context
	mov sp, r1 ;load new

	popa
	pop rs
	ret

; context --
cpu_load_context:
	popv r5, sp

	popa
	pop rs
	ret