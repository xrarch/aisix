procedure Main (* args ksize -- *)
	auto ksize
	ksize!

	auto args
	args!

	(* works this early because the serial port can be polled and is always at the same spot *)
	pointerof SerialWritePolled SysconOut!

	"\n+--------------------------+\n| AISIX (very) early init! |\n+--------------------------+\n" Printf

	PMMInit
	HeapInit
	InterruptsInit
	args@ ArgsInit
	DeviceInit

	ProcInit
	
	"+------------------+\n| AISIX later init |\n+------------------+\n" Printf

	"scheduler should run for the first time\n" Printf
	"diving in...\n" Printf


	pointerof InitProc MakeProcZero uswtch

	while (1) end

	ResetSystem
end

asm "

InitProc:
	li r0, 0xF
	li r1, 0xDEADBEEF
	sys 0

.loop:
	b .loop

"