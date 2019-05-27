(* hack to keep names pretty *)

asm "

; buffer maxchars --
Gets:
	b a3xGets

; char -- 
Putc:
	b a3xPutc

; -- char
Getc:
	b a3xGetc

; -- root dcp
APIDevTree:
	b a3xAPIDevTree

; sz -- ptr
Malloc:
	b a3xMalloc

; sz -- ptr
Calloc:
	b a3xCalloc

; ptr -- 
Free:
	b a3xFree

; path -- node
DevTreeWalk:
	b a3xDevTreeWalk

; --
DeviceParent:
	b a3xDeviceParent

; node -- 
DeviceSelectNode:
	b a3xDeviceSelectNode

; path -- 
DeviceSelect:
	b a3xDeviceSelect

; name -- value
DGetProperty:
	b a3xDGetProperty

; name -- ptr
DGetMethod:
	b a3xDGetMethod

; name -- success
DCallMethod:
	b a3xDCallMethod

; -- 
DeviceExit:
	b a3xDeviceExit

"