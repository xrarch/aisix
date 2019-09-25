#include "<df>/platform/a3x/a3x.h"

var IDiskBD 0

procedure IDiskInit (* bootdev -- *)
	IDiskBD!
end

procedure IReadBlock (* block buffer -- *)
	auto buf
	buf!

	auto block
	block!

	IDiskBD@ a3xDeviceSelectNode
		buf@ block@ "readBlock" a3xDCallMethod drop drop
	a3xDeviceExit
end

procedure IWriteBlock (* block buffer -- *)
	auto buf
	buf!

	auto block
	block!

	IDiskBD@ a3xDeviceSelectNode
		buf@ block@ "writeBlock" a3xDCallMethod drop drop
	a3xDeviceExit
end