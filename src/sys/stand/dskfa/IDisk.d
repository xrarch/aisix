var IDiskBD 0

procedure IDiskInit (* bootdev -- *)
	IDiskBD!
end

procedure IReadBlock (* block buffer -- *)
	auto buf
	buf!

	auto block
	block!

	IDiskBD@ DeviceSelectNode
		buf@ block@ "readBlock" DCallMethod drop drop
	DeviceExit
end

procedure IWriteBlock (* block buffer -- *)
	auto buf
	buf!

	auto block
	block!

	IDiskBD@ DeviceSelectNode
		buf@ block@ "writeBlock" DCallMethod drop drop
	DeviceExit
end