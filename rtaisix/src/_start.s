.extern _Launch

.section text

_start:
.global _start
	la sp, StackTop

	jal _Launch

.idle:
	b .idle

.entry _start

.extern Main

.extern Exit

;a0: argc
;a1: argv
_MainTrampoline:
.global _MainTrampoline
	li t0, 0
	li t3, 0
	mov t2, sp

	beq a0, zero, .done

	subi a0, a0, 1
	addi a1, a1, 8

	lshi t1, a0, 3
	sub sp, sp, t1

.loop:
	beq t0, a0, .done

	l.l t1, a1, zero
	s.l sp, t3, t1

	addi a1, a1, 8
	addi t0, t0, 1
	addi t3, t3, 4
	b .loop

.done:
	swd.l sp, zero, lr
	swd.l sp, zero, t2

	jal Main

	mov a0, v0

	jal Exit

.section bss

.bytes 8192 0
StackTop: