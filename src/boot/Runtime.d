(* barebones runtime lib for vnboot *)

var CIPtr 0

procedure CR (* -- *)
	'\n' Putc
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

; string --
Puts:
	push r30

	popv r5, r0

	li r30, _CIC_Puts
	call _CIC_Call

	pop r30
	ret

; buffer maxchars --
Gets:
	push r30

	popv r5, r1
	
	popv r5, r0

	li r30, _CIC_Gets
	call _CIC_Call

	pop r30
	ret

; char -- 
Putc:
	push r30

	popv r5, r0

	li r30, _CIC_Putc
	call _CIC_Call

	pop r30
	ret

; -- char
Getc:
	push r30

	popv r5, r0

	li r30, _CIC_Getc
	call _CIC_Call

	pushv r5, r0

	pop r30
	ret

; -- root dcp
APIDevTree:
	push r30

	li r30, _CIC_DevTree
	call _CIC_Call

	pushv r5, r0

	mov r0, r1
	pushv r5, r0

	pop r30
	ret

; sz -- ptr
Malloc:
	push r30

	popv r5, r0

	li r30, _CIC_Malloc
	call _CIC_Call

	pushv r5, r0

	pop r30
	ret

; sz -- ptr
Calloc:
	push r30

	popv r5, r0

	li r30, _CIC_Calloc
	call _CIC_Call

	pushv r5, r0

	pop r30
	ret

; ptr -- 
Free:
	push r30

	popv r5, r0

	li r30, _CIC_Free
	call _CIC_Call

	pop r30
	ret

"

procedure Call (* ... ptr -- ... *)
	asm "

	popv r5, r0
	br r0

	"
end

procedure max (* n1 n2 -- max *)
	auto n2
	n2!

	auto n1
	n1!

	if (n2@ n1@ >) n2@ end else n1@ end
end

procedure min (* n1 n2 -- min *)
	auto n2
	n2!

	auto n1
	n1!

	if (n2@ n1@ <) n2@ end else n1@ end
end

procedure itoa (* n buf -- *)
	auto str
	str!

	auto n
	n!

	auto i
	0 i!

	while (1)
		n@ 10 % '0' + str@ i@ + sb
		i@ 1 + i!
		n@ 10 / n!
		if (n@ 0 ==)
			break
		end
	end

	0 str@ i@ + sb
	str@ reverse
end

procedure reverse (* str -- *)
	auto str
	str!

	auto i
	auto j
	auto c

	0 i!
	str@ strlen 1 - j!

	while (i@ j@ <)
		str@ i@ + gb c!

		str@ j@ + gb str@ i@ + sb
		c@ str@ j@ + sb

		i@ 1 + i!
		j@ 1 - j!
	end
end

procedure memset (* ptr size wot -- *)
	auto wot
	wot!

	auto size
	size!

	auto ptr
	ptr!

	auto max
	ptr@ size@ + max!
	while (ptr@ max@ <)
		wot@ ptr@ sb
		ptr@ 1 + ptr!
	end
end

procedure strcmp (* str1 str2 -- equal? *)
	auto str1
	str1!

	auto str2
	str2!

	auto i
	0 i!

	while (str1@ i@ + gb str2@ i@ + gb ==)
		if (str1@ i@ + gb 0 ==)
			1 return
		end

		i@ 1 + i!
	end

	0 return
end

procedure strlen (* str -- size *)
	auto str
	str!

	auto size
	0 size!

	while (str@ gb 0 ~=)
		size@ 1 + size!
		str@ 1 + str!
	end

	size@ return
end

procedure strtok (* str buf del -- next *)
	auto del
	del!

	auto buf
	buf!

	auto str
	str!

	auto i
	0 i!

	if (str@ gb 0 ==)
		0 return
	end

	while (str@ gb del@ ==)
		str@ 1 + str!
	end

	while (str@ i@ + gb del@ ~=)
		auto char
		str@ i@ + gb char!

		char@ buf@ i@ + sb

		if (char@ 0 ==)
			0 return
		end

		i@ 1 + i!
	end

	0 buf@ i@ + sb

	str@ i@ +
end

procedure strzero (* str -- *)
	auto str
	str!

	auto i
	0 i!
	while (str@ i@ + gb 0 ~=)
		0 str@ i@ + sb
		i@ 1 + i!
	end
end

procedure strntok (* str buf del n -- next *)
	auto n
	n!

	auto del
	del!

	auto buf
	buf!

	auto str
	str!

	auto i
	0 i!

	if (str@ gb 0 ==)
		0 return
	end

	while (str@ gb del@ ==)
		str@ 1 + str!
	end

	while (str@ i@ + gb del@ ~=)
		if (i@ n@ >)
			break
		end

		auto char
		str@ i@ + gb char!

		char@ buf@ i@ + sb

		if (char@ 0 ==)
			0 return
		end

		i@ 1 + i!
	end

	0 buf@ i@ + sb

	str@ i@ +
end

procedure strcpy (* dest src -- *)
	auto src
	src!
	auto dest
	dest!

	while (src@ gb 0 ~=)
		src@ gb dest@ sb

		dest@ 1 + dest!
		src@ 1 + src!
	end

	0 dest@ sb
end

procedure atoi (* str -- n *)
	auto str
	str!

	auto i
	auto res
	0 i!
	0 res!
	while (str@ i@ + gb 0 ~=)
		res@ 10 *
		str@ i@ + gb '0' -
		+
		res!

		i@ 1 + i!
	end
	res@ return
end

















