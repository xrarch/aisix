var VCFBStart 0
var VCGWidth 0
var VCGHeight 0

var VCColorBG 0x56
var VCColorFG 0x00

var VCColorOBG 0x56
var VCColorOFG 0x00

const VConsoleBG 0xF
const VConsoleFG 0x0

var VCCurX 0
var VCCurY 0

var VConsoleX 0
var VConsoleY 0

var VCWidth 0
var VCHeight 0

var VCScreenNode 0

const VConsoleFontWidth 8
const VConsoleFontWidthA 7

const VConsoleFontBytesPerRow 1
const VConsoleFontHeight 16

const VConsoleMargin 40

var VCEscape 0

var VCLineLenBuf 0

var VConsoleModified 0

var VCNeedsDraw 1

var VidConPresent 0

asm "

VConsoleFont:
	.static dev/graphics/font-terminus.bmp

"

procedure VidConInit (* -- *)
	GraphicsFramebuffer@ VCFBStart!

	if (GraphicsWidth@ 640 VConsoleMargin + < GraphicsHeight 480 VConsoleMargin + < ||)
		0 VConsoleX!
		0 VConsoleY!

		GraphicsWidth@ VCGWidth!
		GraphicsHeight@ VCGHeight!
	end else
		GraphicsWidth@ 2 / 320 - VConsoleX!
		GraphicsHeight@ 2 / 240 - VConsoleY!

		640 VCGWidth!
		480 VCGHeight!
	end

	VConsoleBG VCColorBG!
	VConsoleFG VCColorFG!

	VCGWidth@ VConsoleFontWidth / VCWidth!
	VCGHeight@ VConsoleFontHeight / VCHeight!

	VCHeight@ 4 * Calloc VCLineLenBuf!

	1 VidConPresent!
end

procedure VConsoleLongestLine (* -- width *)
	auto i
	0 i!

	auto longest
	0 longest!

	while (i@ VCHeight@ <)
		auto len
		i@ 4 * VCLineLenBuf@ + @ len!

		if (len@ longest@ >)
			len@ longest!
		end

		i@ 1 + i!
	end

	longest@
end

procedure VConsoleClear (* -- *)
	VConsoleX@ VConsoleY@ VConsoleLongestLine VConsoleFontWidth * VCHeight@ VConsoleFontHeight * VConsoleBG VConsoleRect

	0 VCCurX!
	0 VCCurY!

	VCLineLenBuf@ VCHeight@ 4 * 0 memset
end

procedure VConsoleRect (* x y w h color -- *)
	GraphicsRectangle
end

procedure VConsoleScroll (* rows -- *)
	auto rows
	rows!

	VConsoleX@ VConsoleY@
	640
	480
	VConsoleBG
	rows@ VConsoleFontHeight *
	GraphicsScroll

	auto k
	VCHeight@ k!

	auto VClb
	VCLineLenBuf@ VClb!

	auto r
	VClb@ r!

	auto max
	VCHeight@ rows@ - 4 * VClb@ + max!

	while (r@ max@ <)
		r@ rows@ 4 * + @ r@ !
		r@ 4 + r!
	end

	VCHeight@ rows@ - 4 * VClb@ + r!
	VCHeight@ 4 * VClb@ + max!

	while (r@ max@ <)
		0 r@ !
		r@ 4 + r!
	end
end

procedure VConsoleDoCur (* color -- *)
	auto color
	color!

	VCCurX@ VConsoleFontWidth * VConsoleX@ + VCCurY@ VConsoleFontHeight * VConsoleY@ + VConsoleFontWidth VConsoleFontHeight color@ VConsoleRect
end

procedure VConsoleClearCur (* -- *)
	VCColorBG@ VConsoleDoCur
end

procedure VConsoleDrawCur (* -- *)
	VCColorFG@ VConsoleDoCur
end

procedure VConsoleNewline (* -- *)
	VCCurX@ VCCurY@ 4 * VCLineLenBuf@ + !

	0 VCCurX!
	VCCurY@ 1 + VCCurY!

	if (VCCurY@ VCHeight@ >=)
		VCHeight@ 1 - VCCurY!
		0 VCCurX!
		1 VConsoleScroll
	end
end

procedure VConsoleBack (* -- *)
	if (VCCurX@ 0 ==)
		if (VCCurY@ 0 >)
			VCCurY@ 1 - VCCurY!
			VCWidth@ 1 - VCCurX!
		end
		return
	end

	VCCurX@ 1 - VCCurX!
end

procedure VConsoleDraw (* -- *)
	0 VCCurX!
	0 VCCurY!

	if (VConsoleX@ 0 ~= VConsoleY@ 0 ~= &&) (* there is at least VConsoleMargin/2 pixels around the edge, do a pretty box *)

		(* edges *)
		VConsoleX@ 4 - VConsoleY@ 4 - VCGWidth@ 8 + VCGHeight@ 8 + 0xF VConsoleRect
		VConsoleX@ 3 - VConsoleY@ 3 - VCGWidth@ 6 + VCGHeight@ 6 + 0x0 VConsoleRect

		VConsoleX@ 2 - VConsoleY@ 2 - VCGWidth@ 4 + VCGHeight@ 4 + VConsoleBG VConsoleRect
	end else (* un-pretty box *)
		VConsoleX@ VConsoleY@ VCGWidth@ VCGHeight@ VConsoleBG VConsoleRect
	end
end

procedure VConsoleTab (* -- *)
	VCCurX@ 8 / 1 + 8 * VCCurX!

	if (VCCurX@ VCWidth@ >=)
		VConsoleNewline
	end
end

var VCEV0 0
var VCEV1 0

var VCEV 0

procedure VConsoleSetColor (* -- *)
	if (VCEV0@ 256 <)
		VCColorFG@ VCColorOFG!
		VCEV0@ VCColorFG!
		return
	end

	if (VCEV0@ 512 <)
		VCColorBG@ VCColorOBG!
		VCEV0@ 256 - VCColorBG!
		return
	end

	if (VCEV0@ 1024 ==)
		VCColorOBG@ VCColorBG!
		VCColorOFG@ VCColorFG!
		return
	end
end

procedure VConsoleParseEscape (* c -- *)
	auto c
	c!

	if (c@ '0' >= c@ '9' <= &&)
		VCEV@ @ 10 * VCEV@ !
		VCEV@ @ c@ '0' - + VCEV@ !
		return
	end

	if (c@ '[' ==) return end
	if (c@ ';' ==) pointerof VCEV1 VCEV! return end
	if (c@ 'm' ==) VConsoleSetColor end
	if (c@ 'c' ==) VConsoleClear end

	0 VCEscape!
end

procedure VConsolePutChar (* char -- *)
	auto char
	char!

	if (VCEscape@) char@ VConsoleParseEscape return end

	if (char@ 0x1b ==)
		pointerof VCEV0 VCEV!
		0 VCEV0!
		0 VCEV1!
		1 VCEscape!
		return
	end

	VConsoleClearCur

	char@ VConsolePutCharF

	VConsoleDrawCur
end

procedure VConsolePutCharF (* char -- *)
	if (VCNeedsDraw@)
		VConsoleDraw
		0 VCNeedsDraw!
	end

	auto char
	char!

	if (char@ '\n' ==)
		VConsoleNewline
		return
	end else if (char@ '\b' ==)
		VConsoleBack
		return
	end else if (char@ '\t' ==)
		VConsoleTab
		return
	end end

	VCCurX@ VConsoleFontWidth * VConsoleX@ + VCCurY@ VConsoleFontHeight * VConsoleY@ + char@ VCColorFG@ VConsoleDrawChar

	VCCurX@ 1 + VCCurX!

	if (VCCurX@ VCWidth@ >=)
		VConsoleNewline
	end
end

(* here be ugly dragons *)

asm "

VCGPPStub:
	push r5

	lri.l r5, GraphicsWidth
	mul r1, r5, r1
	add r1, r1, r0
	lri.l r5, VCFBStart
	add r1, r1, r5
	srr.b r1, r2

	pop r5
	ret

;r0 - char
;r1 - x
;r2 - y
;r3 - color
;draw bitmap character at specified location on screen
VConsoleDrawCharASM:
	cmpi r0, 0x20 ;dont draw if space
	be .spout

	;push r3 ;use r3 as y iterator
	push r4 ;use r4 as x iterator
	push r11 ;use r11 to store ptr to current byte in font to look at
	push r6 ;use r6 to store current byte
	push r7 ;use r7 for scratch in xloop
	push r8 ;use r8 to cache 0x7
	push r9 ;use r9 for more scratch in xloop
	push r10 ;use r10 to store color

	mov r10, r3

	muli r11, r0, VConsoleFontBytesPerRow
	muli r11, r11, VConsoleFontHeight
	addi r11, r11, VConsoleFont
	li r3, 0
.yloop:
	cmpi r3, VConsoleFontHeight
	bge .yend

	;body of y loop

	lrr.l r6, r11

	li r4, 0 ;ctr
	li r8, VConsoleFontWidthA ;reverse ctr
.xloop:
	cmpi r4, VConsoleFontWidth
	bge .ynext

	rsh r7, r6, r8 ;use r4 or r8 depending on bit order
	andi r7, r7, 1
	cmpi r7, 1
	bne .xnext

	;thunk over to GraphicsPutPixel.
	;it expects x,y in r0,r1
	;and color in r2.
	;all of these get trashed so we
	;have to push them first.

	push r0
	push r1
	push r2

	add r0, r1, r4 ;add bx and x iterator
	add r1, r2, r3 ;add by and y iterator
	mov r2, r10 ;get color

	call VCGPPStub

	pop r2
	pop r1
	pop r0

.xnext:
	addi r4, r4, 1
	subi r8, r8, 1
	b .xloop

.ynext:
	addi r11, r11, VConsoleFontBytesPerRow
	addi r3, r3, 1
	b .yloop

.yend:
	pop r10
	pop r9
	pop r8
	pop r7
	pop r6
	pop r11
	pop r4

.spout:
	ret

"

procedure VConsoleDrawChar (* x y char color -- *)
	asm "

	popv r5, r3

	popv r5, r0

	popv r5, r2

	popv r5, r1

	call VConsoleDrawCharASM

	"
end