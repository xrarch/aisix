procedure platformPutc (* c -- *)
	auto rs
	InterruptDisable rs!

	a3xPutc

	rs@ InterruptRestore
end

procedure platformGetc (* -- c *)
	auto rs
	InterruptDisable rs!

	auto c
	ERR c!
	while (c@ ERR ==)
		a3xGetc c!

		rs@ InterruptRestore
		InterruptDisable rs!
	end

	rs@ InterruptRestore

	c@
end