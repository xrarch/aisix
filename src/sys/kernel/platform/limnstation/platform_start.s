platform_start_lowlevel:
	;r0 contains pointer to firmware API
	pushv r5, r0
	call a3xInit

	;r2 contains args
	pushv r5, r2

	;r3 contains image size
	pushv r5, r3

	b platform_start