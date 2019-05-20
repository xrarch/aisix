table Kinnow3Dev
	0x4B494E58
	"kinnow3"
	pointerof Kinnow3Board
endtable

var KinnowSlotSpace 0
var KinnowSlot 0

var KinnowFBStart 0
var KinnowPipeStart 0

const KinnowCmdPorts 0x4000
const KinnowSlotFB 0x100000

const KinnowGPUCmdPort 0
const KinnowGPUPortA 4
const KinnowGPUPortB 8
const KinnowGPUPortC 12
const KinnowGPUPixelPipe 16

const KinnowGPUInfo 0x1
const KinnowGPURectangle 0x2
const KinnowGPUScroll 0x3
const KinnowGPUVsync 0x4
const KinnowGPUSetPPR 0x5
const KinnowGPUSetPPW 0x6
const KinnowGPUSetPPI 0x7
const KinnowGPUS2S 0x8

var KinnowWidth 0
var KinnowHeight 0

var KinnowVsyncList 0

procedure Kinnow3Board (* slot slotspace -- *)
	auto slotspace
	slotspace!

	auto kslot
	kslot!

	if (KinnowSlotSpace@ 0 ~=)
		return
	end

	kslot@ KinnowSlot!

	slotspace@ KinnowSlotSpace!

	auto w
	auto h
	KinnowInfo w! h!

	if (w@ 0 ==)
		return
	end

	KinnowSlotSpace@ KinnowSlotFB + KinnowFBStart!
	KinnowSlotSpace@ KinnowCmdPorts + KinnowGPUPixelPipe + KinnowPipeStart!

	w@ KinnowWidth!
	h@ KinnowHeight!

	ListCreate KinnowVsyncList!

	KinnowVsyncOn
end

procedure Kinnow3Init (* -- *)
	Kinnow3Dev EBusBoardRegister
end

procedure KinnowCommand (* cmd -- *)
	auto pbase
	KinnowSlotSpace@ KinnowCmdPorts + pbase!

	auto cmd
	cmd!

	cmd@ pbase@ sb

	while (pbase@ gb 0 ~=) end
end

procedure KinnowPortA (* -- v *)
	KinnowSlotSpace@ KinnowCmdPorts + KinnowGPUPortA + @
end

procedure KinnowPortB (* -- v *)
	KinnowSlotSpace@ KinnowCmdPorts + KinnowGPUPortB + @
end

procedure KinnowPortC (* -- v *)
	KinnowSlotSpace@ KinnowCmdPorts + KinnowGPUPortC + @
end

procedure KinnowOutPortA (* v -- *)
	KinnowSlotSpace@ KinnowCmdPorts + KinnowGPUPortA + !
end

procedure KinnowOutPortB (* v -- *)
	KinnowSlotSpace@ KinnowCmdPorts + KinnowGPUPortB + !
end

procedure KinnowOutPortC (* v -- *)
	KinnowSlotSpace@ KinnowCmdPorts + KinnowGPUPortC + !
end

procedure KinnowInfo (* -- h w *)
	auto rs
	InterruptDisable rs!

	KinnowGPUInfo KinnowCommand
	
	KinnowPortB
	KinnowPortA

	rs@ InterruptRestore
end

procedure KinnowSetPixelRead (* x y w h -- *)
	auto h
	h!

	auto w
	w!

	auto y
	y!

	auto x
	x!

	auto rs
	InterruptDisable rs!

	auto cxy
	x@ 16 << y@ | cxy!

	auto cwh
	w@ 16 << h@ | cwh!

	cxy@ KinnowOutPortA
	cwh@ KinnowOutPortB

	KinnowGPUSetPPR KinnowCommand

	rs@ InterruptRestore
end

procedure KinnowSetPixelWriteRaw (* x y w h fg bg bitd writetype -- *)
	auto writetype
	writetype!

	auto bitd
	bitd!

	auto bg
	bg!

	auto fg
	fg!

	auto h
	h!

	auto w
	w!

	auto y
	y!

	auto x
	x!

	auto rs
	InterruptDisable rs!

	auto cxy
	x@ 16 << y@ | cxy!

	auto cwh
	w@ 16 << h@ | cwh!

	auto fbw
	fg@ 24 << bg@ 16 << | bitd@ 8 << | writetype@ | fbw!

	cxy@ KinnowOutPortA
	cwh@ KinnowOutPortB
	fbw@ KinnowOutPortC

	KinnowGPUSetPPW KinnowCommand

	rs@ InterruptRestore
end

procedure KinnowSetPixelWriteBits (* x y w h fg bg bitd -- *)
	1 KinnowSetPixelWriteRaw
end

procedure KinnowSetPixelWrite (* x y w h -- *)
	0 0 0 0 KinnowSetPixelWriteRaw
end

procedure KinnowSetPixelIgnore (* color -- *)
	auto rs
	InterruptDisable rs!

	KinnowOutPortA

	KinnowGPUSetPPI KinnowCommand

	rs@ InterruptRestore
end

procedure KinnowBlitS2S (* x1 y1 x2 y2 w h -- *)
	auto h
	h!

	auto w
	w!

	auto y2
	y2!

	auto x2
	x2!

	auto y1
	y1!

	auto x1
	x1!

	(* todo *)
end

procedure KinnowPipeRead (* to count -- *)
	auto count
	count!

	auto to
	to!

	KinnowPipeStart@ to@
	0 1
	count@
	0
	DMATransfer
end

procedure KinnowPipeWrite (* from count -- *)
	auto count
	count!

	auto from
	from!

	from@ KinnowPipeStart@
	1 0
	count@
	0
	DMATransfer
end

procedure KinnowBlitBack (* x y w h bitmap -- *)
	auto ptr
	ptr!

	auto h
	h!

	auto w
	w!

	auto y
	y!

	auto x
	x!

	x@ y@ w@ h@ KinnowSetPixelRead

	ptr@ w@ h@ * KinnowPipeRead
end

procedure KinnowBlit (* x y w h bmp ignore -- *)
	auto ignore
	ignore!

	auto ptr
	ptr!

	auto h
	h!

	auto w
	w!

	auto y
	y!

	auto x
	x!

	ignore@ KinnowSetPixelIgnore
	x@ y@ w@ h@ KinnowSetPixelWrite

	ptr@ w@ h@ * KinnowPipeWrite
end

procedure KinnowBlitBits (* x y w h fg bg bitd bmp -- *)
	auto ptr
	ptr!

	auto bitd
	bitd!

	auto bg
	bg!

	auto fg
	fg!

	auto h
	h!

	auto w
	w!

	auto y
	y!

	auto x
	x!

	x@ y@ w@ h@ fg@ bg@ bitd@ KinnowSetPixelWriteBits

	ptr@ w@ h@ * 8 / KinnowPipeWrite
end

procedure KinnowVsyncAdd (* handler -- *)
	KinnowVsyncList@ ListInsert
end

procedure KinnowVsyncInt (* -- *)
	auto n
	KinnowVsyncList@ ListHead n!

	while (n@ 0 ~=)
		n@ ListNodeValue Call

		n@ ListNodeNext n!
	end
end

procedure KinnowVsyncOn (* -- *)
	auto rs
	InterruptDisable rs!

	pointerof KinnowVsyncInt KinnowSlot@ EBusSlotInterruptRegister

	KinnowGPUVsync KinnowCommand

	rs@ InterruptRestore
end

procedure KinnowScroll (* x y w h color rows -- *)
	auto rs
	InterruptDisable rs!

	auto rows
	rows!

	auto color
	color!

	auto h
	h!

	auto w
	w!

	auto y
	y!

	auto x
	x!

	auto cxy
	x@ 16 << y@ | cxy!

	auto cwh
	w@ 16 << h@ | cwh!

	auto crc
	rows@ 16 << color@ | crc!

	cxy@ KinnowOutPortA
	cwh@ KinnowOutPortB
	crc@ KinnowOutPortC

	KinnowGPUScroll KinnowCommand

	rs@ InterruptRestore
end

procedure KinnowRectangle (* x y w h color -- *)
	auto rs
	InterruptDisable rs!

	auto color
	color!

	auto h
	h!

	auto w
	w!

	auto y
	y!

	auto x
	x!

	auto cxy
	x@ 16 << y@ | cxy!

	auto cwh
	w@ 16 << h@ | cwh!

	cxy@ KinnowOutPortA
	cwh@ KinnowOutPortB
	color@ KinnowOutPortC

	KinnowGPURectangle KinnowCommand

	rs@ InterruptRestore
end