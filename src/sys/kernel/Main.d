procedure Main (* args ksize -- *)
	auto ksize
	ksize!

	auto args
	args!

	"\n+--------------------------+\n| AISIX (very) early init! |\n+--------------------------+\n" Printf

	ksize@ "image size: ~%d bytes\n" Printf

	PMMInit
	HeapInit
	InterruptsInit
	args@ ArgsInit
	DeviceInit
	
"  ___ _____ _____ _______   ___                        _ 
 / _ |_   _/  ___|_   _\\ \\ / | |                      | |
/ /_\\ \\| | \\ `--.  | |  \\ V /| | _____ _ __ _ __   ___| |
|  _  || |  `--. \\ | |  /   \\| |/ / _ | '__| '_ \\ / _ | |
| | | _| |_/\\__/ /_| |_/ /^\\ |   |  __| |  | | | |  __| |
\\_| |_\\___/\\____/ \\___/\\/   \\|_|\\_\\___|_|  |_| |_|\\___|_|
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
	li r0, 0xF
	sys 0
	li r0, 0xf
	sys 0

.loop:
	b .loop

"