.extern _Launch

.section text

_start:
.global _start
	la   sp, StackTop

	jal  _Launch

.idle:
	b    .idle

.entry _start

.extern Main

.extern Exit

;a0: argc
;a1: argv
_MainTrampoline:
.global _MainTrampoline
	li   t0, 0
	li   t3, 0
	mov  t2, sp

	beq  a0, .done

	subi a0, a0, 1
	addi a1, a1, 8

	lshi t1, a0, 3
	sub  sp, sp, t1

.loop:
	sub  t1, t0, a0
	beq  t1, .done

	mov  t1, long [a1]
	mov  long [sp + t3], t1

	addi a1, a1, 8
	addi t0, t0, 1
	addi t3, t3, 4
	b    .loop

.done:
	subi sp, sp, 4
	mov  long [sp], lr

	jal  Main

	jal  Exit

.section bss

.bytes 4096 0
StackTop: