(* called by platform_start *)
procedure AisixStart (* args imagesz loadbase -- *)
	auto ldbase
	ldbase!

	auto imagesz
	imagesz!

	auto args
	args!

	AISIX_MINOR AISIX_MAJOR "aisix release %d.%d\n" Printf
	"Copyright (c) 2019 Will. All Rights Reserved\n" Printf
	imagesz@ ldbase@ "kernel image @ 0x%x; ~%d bytes\n\n" Printf

	ldbase@ imagesz@ PMMInit

	HeapInit

	args@ ArgsInit

	InterruptsInit

	TaskInit

	ThreadInit

	pointerof BootstrapThread KernelThreadCreate KernelThreadResume

	Scheduler

	while (1) end
end

procedure BootstrapThread (* -- *)
	InterruptDisable drop

	TaskCurrent@ Task_Name + @ "bootstrap thread up. current task: %s\n" Printf

	BufferInit

	DeviceInit

	IOInit

	InterruptEnable drop

	while (1) yield end
end