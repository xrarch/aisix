platform_panic:
	li rs, 0x80000000

	call platform_interrupt_throwaway

	call cpu_panic