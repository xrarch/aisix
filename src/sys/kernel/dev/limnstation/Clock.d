const ClockPortCmd 0x20
const ClockPortA 0x21

const ClockDefaultInterval 25 (* every 25 ms *)

var ClockUptimeMS 0
var ClockInterval 0

procedure ClockInit (* -- *)
	pointerof ClockInt 0x36 PBInterruptRegister
	ClockDefaultInterval ClockSetInterval (* set clock ticking *)
end

procedure ClockInt (* -- *)
	ClockInterval@ ClockUptimeMS@ + ClockUptimeMS!

	ThreadTick
end

procedure ClockWait (* ms -- *)
	auto ms
	ms!

	auto wu
	ClockUptimeMS@ ms@ + wu!

	while (ClockUptimeMS@ wu@ <)
		THREAD_RUNNABLE ThreadCurrent@ Thread_Status + !
		yield
	end
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