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
	EarlyDeviceInit

	ProcInit

	auto mp2
	pointerof Main2 MakeProcZero mp2!

	pointerof CoolTestProcess
	"cooltest"
	MakeKernelProcess drop

	pointerof CoolTestProcess2
	"cooltest2"
	MakeKernelProcess drop

	mp2@ uswtch

	while (1) end

	ResetSystem
end

procedure Main2 (* -- *)
	"\n-- main2 --\n" Printf

	LateDeviceInit
	
	"\n+------------------+\n| AISIX later init |\n+------------------+\n" Printf

	"scheduler should run for the first time, then kernel task will idle forever\n" Printf
	"diving in...\n" Printf

	1 DoScheduler!
end

procedure CoolTestProcess (* -- *)
	auto lc
	-1 lc!

	while (1)
		if (lc@ ClockUptimeMS@ ~=)
			ClockUptimeMS@ lc!
			"wow\n" Printf
		end
	end
end

procedure CoolTestProcess2 (* -- *)
	auto lc
	-1 lc!

	while (1)
		if (lc@ ClockUptimeMS@ ~=)
			ClockUptimeMS@ lc!
			"heck\n" Printf
		end
	end
end