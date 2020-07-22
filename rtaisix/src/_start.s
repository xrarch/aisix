.extern _Launch

.section text

_start:
.global _start
	la sp, StackTop

	jal _Launch

.idle:
	b .idle

.entry _start

.section bss

.bytes 8192 0
StackTop: