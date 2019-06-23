#include "cpu/limn1k/limn1k.d"

#include "platform/limnstation/firmware.d"
#include "platform/limnstation/platform_start.d"
#include "platform/limnstation/polltty.d"
#include "platform/limnstation/memory.d"
#include "platform/limnstation/interrupt.d"
#include "platform/limnstation/mmu.d"
#include "platform/limnstation/shutdown.d"

asm "

.include platform/limnstation/panic.s

"