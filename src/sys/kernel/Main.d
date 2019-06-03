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

(*
	
"  ___ _____ _____ _______   ___                        _ 
 / _ \\_   _/  ___|_   _\\ \\ / / |                      | |
/ /_\\ \\| | \\ `--.  | |  \\ V /| | _____ _ __ _ __   ___| |
|  _  || |  `--. \\ | |  /   \\| |/ / _ \\ '__| '_ \\ / _ \\ |
| | | || |_/\\__/ /_| |_/ /^\\ \\   <  __/ |  | | | |  __/ |
\\_| |_|___/\\____/ \\___/\\/   \\/_|\\_\\___|_|  |_| |_|\\___|_|
" Printf

*)

	ProcInit

	auto proc
	pointerof IdleProc MakeProcZero proc!

	pointerof InitProc MakeProcZero drop

	proc@ "pid0 (idleproc): pcb@%x\n" Printf

	"uswtch'ing into pid0\n" Printf

	1 DoScheduler!

	proc@ swtch

	while (1) end

	ResetSystem
end

asm "

;performs a yield syscall over and over
IdleProc:
	li r0, 3
	sys 0
	b IdleProc

InitProc:
	li r0, 1
	li r1, 0xDEADBEEF
	sys 0

.loop:
	b .loop

"