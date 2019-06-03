const ClockPortCmd 0x20
const ClockPortA 0x21

const ClockDefaultInterval 250 (* every 25 ms *)

var ClockUptimeMS 0
var ClockInterval 0

procedure ClockInit (* -- *)
	"clock: init\n" Printf

	pointerof ClockInt 0x36 PBInterruptRegister
	ClockDefaultInterval ClockSetInterval (* set clock ticking *)
end

procedure ClockInt (* -- *)
	ClockInterval@ ClockUptimeMS@ + ClockUptimeMS!

	auto pln
	ProcList@ ListLength pln!

	250 pln@ / PROCMINQUANTUM max ClockSetInterval

	if (DoScheduler@)
		PRUNNABLE CurProc@ Proc_Status + !
		Schedule
	end
end

procedure ClockWait (* ms -- *)
	auto ms
	ms!

	auto wu
	ClockUptimeMS@ ms@ + wu!

	while (ClockUptimeMS@ wu@ <) end
end

procedure ClockUptime (* -- ms *)
	ClockUptimeMS@
end

procedure ClockSetInterval (* ms -- *)
	auto ms
	ms!

	ms@ ClockInterval!

	auto rs
	InterruptDisable rs!

	ms@ ClockPortA DCitronOutl
	1 ClockPortCmd DCitronCommand

	rs@ InterruptRestore
end