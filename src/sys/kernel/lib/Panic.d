procedure Panic (* fmt -- *)
	"\naisix PANIC: " Printf

	Printf

	CurProc@ Proc_Name + @ CurProc@ Proc_PID + @ "\nwas executing pid%d (%s)\n" Printf

	while (1) end
end