cpu_panic:
	li r5, 0x200000 ;reset dragonfruit stack
	li sp, 0x1FF000 ;reset kernel stack
	li rs, 0x80000000

.loop:
	b .loop