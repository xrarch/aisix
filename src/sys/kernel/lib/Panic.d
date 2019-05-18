procedure Panic (* fmt -- *)
	"\n\naisix PANIC: " Printf

	Printf

	CurProc@ Proc_Name + @ CurProc@ Proc_PID + @ "was executing pid%d (%s)\n" Printf

	while (1) end
end