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

	sub a0, a0, 1
	add a1, a1, 8

	lsh t1, a0, 3
	sub sp, sp, t1

.loop:
	beq t0, a0, .done

	mov t1, long [a1]
	mov long [sp + t3], t1

	add a1, a1, 8
	add t0, t0, 1
	add t3, t3, 4
	b .loop

.done:
	push lr
	push t2

	jal Main

	mov a0, v0

	jal Exit

.section bss

.bytes 4096 0
StackTop: