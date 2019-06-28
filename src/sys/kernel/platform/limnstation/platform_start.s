platform_start_lowlevel:
	;r1 contains a3x boot node
	pushv r5, r1

	;r2 contains args
	pushv r5, r2

	;r3 contains image size
	pushv r5, r3

	;fw context
	pushv r5, r4
	;r0 contains pointer to firmware API
	pushv r5, r0
	call a3xInit

	b platform_start