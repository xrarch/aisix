asm preamble "

.include cpu/limn1k/start.s

"

asm "

.include cpu/limn1k/reset.s
.include cpu/limn1k/interrupts.s
.include cpu/limn1k/kernel_entry.s
.include cpu/limn1k/cswtch.s
.include cpu/limn1k/panic.s

"

#include "cpu/limn1k/interrupts.d"
#include "cpu/limn1k/faults.d"
#include "cpu/limn1k/thread.d"
#include "cpu/limn1k/debug.d"