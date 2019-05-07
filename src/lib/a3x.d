var CIPtr 0

procedure a3xInit (* -- *)
	CIPtr!
end

asm "

;r30 - call num
_CIC_Call:
	push r29
	lri.l r29, CIPtr
	add r30, r30, r29
	lrr.l r30, r30

	call .e
	pop r29
	ret

.e:
	br r30

_CIC_Putc === 0
_CIC_Getc === 4
_CIC_Gets === 8
_CIC_Puts === 12
_CIC_DevTree === 16
_CIC_Malloc === 20
_CIC_Calloc === 24
_CIC_Free === 28

_CIC_DevTreeWalk === 32
_CIC_DeviceParent === 36
_CIC_DeviceSelectNode === 40
_CIC_DeviceSelect === 44
_CIC_DeviceDGetProperty === 48
_CIC_DeviceDGetMethod === 52
_CIC_DeviceDCallMethod === 56
_CIC_DeviceExit === 60

; string --
Puts:
	push r30

	li r30, _CIC_Puts
	call _CIC_Call

	pop r30
	ret

; buffer maxchars --
Gets:
	push r30

	li r30, _CIC_Gets
	call _CIC_Call

	pop r30
	ret

; char -- 
Putc:
	push r30

	li r30, _CIC_Putc
	call _CIC_Call

	pop r30
	ret

; -- char
Getc:
	push r30

	li r30, _CIC_Getc
	call _CIC_Call

	pop r30
	ret

; -- root dcp
APIDevTree:
	push r30

	li r30, _CIC_DevTree
	call _CIC_Call

	pop r30
	ret

; sz -- ptr
Malloc:
	push r30

	li r30, _CIC_Malloc
	call _CIC_Call

	pop r30
	ret

; sz -- ptr
Calloc:
	push r30

	li r30, _CIC_Calloc
	call _CIC_Call

	pop r30
	ret

; ptr -- 
Free:
	push r30

	li r30, _CIC_Free
	call _CIC_Call

	pop r30
	ret

; path -- node
DevTreeWalk:
	push r30

	li r30, _CIC_DevTreeWalk
	call _CIC_Call

	pop r30
	ret

; --
DeviceParent:
	push r30

	li r30, _CIC_DeviceParent
	call _CIC_Call

	pop r30
	ret

; node -- 
DeviceSelectNode:
	push r30

	li r30, _CIC_DeviceSelectNode
	call _CIC_Call

	pop r30
	ret

; path -- 
DeviceSelect:
	push r30

	li r30, _CIC_DeviceSelect
	call _CIC_Call

	pop r30
	ret

; name -- value
DGetProperty:
	push r30

	li r30, _CIC_DeviceDGetProperty
	call _CIC_Call

	pop r30
	ret

; name -- ptr
DGetMethod:
	push r30

	li r30, _CIC_DeviceDGetMethod
	call _CIC_Call

	pop r30
	ret

; name -- success
DCallMethod:
	push r30

	li r30, _CIC_DeviceDCallMethod
	call _CIC_Call

	pop r30
	ret

; -- 
DeviceExit:
	push r30

	li r30, _CIC_DeviceExit
	call _CIC_Call

	pop r30
	ret

"


















