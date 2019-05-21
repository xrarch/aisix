procedure Main (* args ksize -- *)
	auto ksize
	ksize!

	auto args
	args!

	(* works this early because the serial port can be polled and is always at the same spot *)
	pointerof SerialWritePolled SysconSetOut

	"\n+--------------------------+\n| AISIX (very) early init! |\n+--------------------------+\n" Printf

	PMMInit
	HeapInit
	InterruptsInit
	args@ ArgsInit
	DeviceInit
	
"  ___ _____ _____ _______   __
 / _ \\_   _/  ___|_   _\\ \\ / /
/ /_\\ \\| | \\ `--.  | |  \\ V / 
|  _  || |  `--. \\ | |  /   \\ 
| | | || |_/\\__/ /_| |_/ /^\\ \\
\\_| |_|___/\\____/ \\___/\\/   \\/
" Printf

	ProcInit

	auto proc
	pointerof InitProc MakeProcZero proc!

	proc@ "pid0 (init): pcb@%x\n" Printf

	"uswtch'ing into pid0\n" Printf

	1 DoScheduler!

	proc@ uswtch

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