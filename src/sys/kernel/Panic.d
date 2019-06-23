procedure Panic (* fstr -- *)
	InterruptDisable drop

	CR

	1 SysconSwitchVC drop

	"aisix PANIC: " Printf
	Printf

	platform_panic

	while (1) end
end