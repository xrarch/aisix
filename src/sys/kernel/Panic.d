procedure Panic (* fstr -- *)
	InterruptDisable drop

	"\naisix PANIC: " Printf
	Printf

	cpu_panic

	while (1) end
end