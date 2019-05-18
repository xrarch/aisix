var GCFBStart 0
var GCGWidth 0
var GCGHeight 0

var GCColorBG 0x56
var GCColorFG 0x00

var GCColorOBG 0x56
var GCColorOFG 0x00

const GConsoleBG 0xF
const GConsoleFG 0x0

var GCCurX 0
var GCCurY 0

var GConsoleX 0
var GConsoleY 0

var GCWidth 0
var GCHeight 0

var GCScreenNode 0

const GConsoleFontWidth 8
const GConsoleFontWidthA 7

const GConsoleFontBytesPerRow 1
const GConsoleFontHeight 16

var GCEscape 0

var GCLineLenBuf 0

var GConsoleModified 0

var GCNeedsInit 1

var VidConPresent 0

asm "

GConsoleFont:
	.static dev/graphics/font-terminus.bmp

"

procedure VidConInit (* -- *)
	GraphicsFramebuffer@ GCFBStart!

	if (GraphicsWidth@ 650 < GraphicsHeight 490 < ||)
		0 GConsoleX!
		0 GConsoleY!

		GraphicsWidth@ GCGWidth!
		GraphicsHeight@ GCGHeight!
	end else
		GraphicsWidth@ 2 / 320 - GConsoleX!
		GraphicsHeight@ 2 / 240 - GConsoleY!

		640 GCGWidth!
		480 GCGHeight!
	end

	GConsoleBG GCColorBG!
	GConsoleFG GCColorFG!

	GCGWidth@ GConsoleFontWidth / GCWidth!
	GCGHeight@ GConsoleFontHeight / GCHeight!

	GCHeight@ 4 * Calloc GCLineLenBuf!

	1 VidConPresent!
end

procedure GConsoleLongestLine (* -- width *)
	auto i
	0 i!

	auto longest
	0 longest!

	while (i@ GCHeight@ <)
		auto len
		i@ 4 * GCLineLenBuf@ + @ len!

		if (len@ longest@ >)
			len@ longest!
		end

		i@ 1 + i!
	end

	longest@
end

procedure GConsoleClear (* -- *)
	GConsoleX@ GConsoleY@ GConsoleLongestLine GConsoleFontWidth * GCHeight@ GConsoleFontHeight * GConsoleBG GConsoleRect

	0 GCCurX!
	0 GCCurY!

	GCLineLenBuf@ GCHeight@ 4 * 0 memset
end

procedure GConsoleRect (* x y w h color -- *)
	GraphicsRectangle
end

procedure GConsoleScroll (* rows -- *)
	auto rows
	rows!

	GConsoleX@ GConsoleY@
	640
	480
	GConsoleBG
	rows@ GConsoleFontHeight *
	GraphicsScroll

	auto k
	GCHeight@ k!

	auto gclb
	GCLineLenBuf@ gclb!

	auto r
	gclb@ r!

	auto max
	GCHeight@ rows@ - 4 * gclb@ + max!

	while (r@ max@ <)
		r@ rows@ 4 * + @ r@ !
		r@ 4 + r!
	end

	GCHeight@ rows@ - 4 * gclb@ + r!
	GCHeight@ 4 * gclb@ + max!

	while (r@ max@ <)
		0 r@ !
		r@ 4 + r!
	end
end

procedure GConsoleDoCur (* color -- *)
	auto color
	color!

	GCCurX@ GConsoleFontWidth * GConsoleX@ + GCCurY@ GConsoleFontHeight * GConsoleY@ + GConsoleFontWidth GConsoleFontHeight color@ GConsoleRect
end

procedure GConsoleClearCur (* -- *)
	GCColorBG@ GConsoleDoCur
end

procedure GConsoleDrawCur (* -- *)
	GCColorFG@ GConsoleDoCur
end

procedure GConsoleNewline (* -- *)
	GCCurX@ GCCurY@ 4 * GCLineLenBuf@ + !

	0 GCCurX!
	GCCurY@ 1 + GCCurY!

	if (GCCurY@ GCHeight@ >=)
		GCHeight@ 1 - GCCurY!
		0 GCCurX!
		1 GConsoleScroll
	end
end

procedure GConsoleBack (* -- *)
	if (GCCurX@ 0 ==)
		if (GCCurY@ 0 >)
			GCCurY@ 1 - GCCurY!
			GCWidth@ 1 - GCCurX!
		end
		return
	end

	GCCurX@ 1 - GCCurX!
end

procedure GConsoleInit (* -- *)
	GConsoleX@ GConsoleY@ GCGWidth@ GCGHeight@ GConsoleBG GConsoleRect
end

procedure GConsoleTab (* -- *)
	GCCurX@ 8 / 1 + 8 * GCCurX!

	if (GCCurX@ GCWidth@ >=)
		GConsoleNewline
	end
end

var GCEV0 0
var GCEV1 0

var GCEV 0

procedure GConsoleSetColor (* -- *)
	if (GCEV0@ 256 <)
		GCColorFG@ GCColorOFG!
		GCEV0@ GCColorFG!
		return
	end

	if (GCEV0@ 512 <)
		GCColorBG@ GCColorOBG!
		GCEV0@ 256 - GCColorBG!
		return
	end

	if (GCEV0@ 1024 ==)
		GCColorOBG@ GCColorBG!
		GCColorOFG@ GCColorFG!
		return
	end
end

procedure GConsoleParseEscape (* c -- *)
	auto c
	c!

	if (c@ '0' >= c@ '9' <= &&)
		GCEV@ @ 10 * GCEV@ !
		GCEV@ @ c@ '0' - + GCEV@ !
		return
	end

	if (c@ '[' ==) return end
	if (c@ ';' ==) pointerof GCEV1 GCEV! return end
	if (c@ 'm' ==) GConsoleSetColor end
	if (c@ 'c' ==) GConsoleClear end

	0 GCEscape!
end

procedure GConsolePutChar (* char -- *)
	auto char
	char!

	if (GCEscape@) char@ GConsoleParseEscape return end

	if (char@ 0x1b ==)
		pointerof GCEV0 GCEV!
		0 GCEV0!
		0 GCEV1!
		1 GCEscape!
		return
	end

	GConsoleClearCur

	char@ GConsolePutCharF

	GConsoleDrawCur
end

procedure GConsolePutCharF (* char -- *)
	if (GCNeedsInit@)
		GConsoleInit
		0 GCNeedsInit!
	end

	auto char
	char!

	if (char@ '\n' ==)
		GConsoleNewline
		return
	end else if (char@ '\b' ==)
		GConsoleBack
		return
	end else if (char@ '\t' ==)
		GConsoleTab
		return
	end end

	GCCurX@ GConsoleFontWidth * GConsoleX@ + GCCurY@ GConsoleFontHeight * GConsoleY@ + char@ GCColorFG@ GConsoleDrawChar

	GCCurX@ 1 + GCCurX!

	if (GCCurX@ GCWidth@ >=)
		GConsoleNewline
	end
end

(* here be ugly dragons *)

asm "

GCGPPStub:
	push r5

	lri.l r5, GraphicsWidth
	mul r1, r5, r1
	add r1, r1, r0
	lri.l r5, GCFBStart
	add r1, r1, r5
	srr.b r1, r2

	pop r5
	ret

;r0 - char
;r1 - x
;r2 - y
;r3 - color
;draw bitmap character at specified location on screen
GConsoleDrawCharASM:
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

	muli r11, r0, GConsoleFontBytesPerRow
	muli r11, r11, GConsoleFontHeight
	addi r11, r11, GConsoleFont
	li r3, 0
.yloop:
	cmpi r3, GConsoleFontHeight
	bge .yend

	;body of y loop

	lrr.l r6, r11

	li r4, 0 ;ctr
	li r8, GConsoleFontWidthA ;reverse ctr
.xloop:
	cmpi r4, GConsoleFontWidth
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

	call GCGPPStub

	pop r2
	pop r1
	pop r0

.xnext:
	addi r4, r4, 1
	subi r8, r8, 1
	b .xloop

.ynext:
	addi r11, r11, GConsoleFontBytesPerRow
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

procedure GConsoleDrawChar (* x y char color -- *)
	asm "

	popv r5, r3

	popv r5, r0

	popv r5, r2

	popv r5, r1

	call GConsoleDrawCharASM

	"
end