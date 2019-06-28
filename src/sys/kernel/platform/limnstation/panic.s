platform_panic:
	li rs, 0x80000000

	call platform_interrupt_throwaway

	call platform_firmware_restore

	;shouldn't reach here
.hang:
	b .hang