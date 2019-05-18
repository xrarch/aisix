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

	2
	pointerof CoolTestProcess
	0
	0
	"cooltest"
	ProcSkeleton drop

	2
	pointerof CoolTestProcess2
	0
	0
	"cooltest2"
	ProcSkeleton drop

	mp2@ uswtch

	while (1) end

	ResetSystem
end

procedure Main2 (* -- *)
	LateDeviceInit
	
	1 DoScheduler!

	while (1) end
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