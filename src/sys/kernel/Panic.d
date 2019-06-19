procedure Panic (* fstr -- *)
	InterruptDisable drop

	CR

	1 SysconSwitchVC drop

	"aisix PANIC: " Printf
	Printf

	cpu_panic

	asm "brk"

	while (1) end
end