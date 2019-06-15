cpu_panic:
	li r5, 0x200000 ;reset dragonfruit stack
	li sp, 0x1FF000 ;reset kernel stack

.loop:
	b .loop