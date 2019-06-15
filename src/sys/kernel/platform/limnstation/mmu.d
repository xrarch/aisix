const MMUConfigBase 0xB8000000
const MMURegisterBase 0xB8000004
const MMURegisterBounds 0xB8000008
const MMURegisterPageTable 0xB800000C
const MMURegisterFaultingAddr 0xB8000010

procedure MMUInit (* -- *)
	0 MMUSetBase
	0xFFFFFFFF MMUSetBounds
end

procedure MMUSetBase (* base -- *)
	MMURegisterBase!
end

procedure MMUSetBounds (* bounds -- *)
	MMURegisterBounds!
end