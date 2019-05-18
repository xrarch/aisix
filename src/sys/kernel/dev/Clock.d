const ClockPortCmd 0x20
const ClockPortA 0x21

const ClockDefaultInterval 1 (* every 1 ms *)

var ClockUptimeMS 0
var ClockInterval 0

procedure EarlyClockInit (* -- *)
	"clock: early init\n" Printf

	pointerof ClockInt 0x36 PBInterruptRegister
end

procedure LateClockInit (* -- *)
	"clock: late init\n" Printf

	ClockDefaultInterval ClockSetInterval (* set clock ticking *)
end

procedure ClockInt (* -- *)
	ClockInterval@ ClockUptimeMS@ + ClockUptimeMS!

	if (DoScheduler@)
		PRUNNABLE 0 Schedule
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