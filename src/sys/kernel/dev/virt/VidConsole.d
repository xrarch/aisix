var VCFBStart 0
var VCGWidth 0
var VCGHeight 0

var VCColorBG 0x56
var VCColorFG 0x00

var VCColorOBG 0x56
var VCColorOFG 0x00

const VConsoleBG 154
const VConsoleFG 0x0F

var VCCurX 0
var VCCurY 0

var VConsoleX 0
var VConsoleY 0

var VCWidth 0
var VCHeight 0

const VConsoleFontWidth 6
const VConsoleFontWidthA 5

const VConsoleFontBytesPerRow 1
const VConsoleFontHeight 12

const VConsoleFontBitD 0

const VConsoleMargin 80

const VCTargetCWidth 80
const VCTargetCHeight 30

var VCEscape 0

var VCLineLenBuf 0

var VConsoleModified 0

var VCNeedsDraw 1

var VidConPresent 0

asm "

VConsoleFont:
	.static dev/virt/font-haiku.bmp

"

procedure VConsoleNeedsDraw (* -- *)
	1 VCNeedsDraw!
end

procedure VidConInit (* -- *)
	if (GraphicsPresent@ ~~)
		"vidcon: no graphics, aborting\n" Printf
		return
	end

	GraphicsFramebuffer@ VCFBStart!

	auto twidth
	auto theight

	VCTargetCWidth VConsoleFontWidth * twidth!
	VCTargetCHeight VConsoleFontHeight * theight!

	if (GraphicsWidth@ twidth@ VConsoleMargin + < GraphicsHeight theight@ VConsoleMargin + < ||)
		0 VConsoleX!
		0 VConsoleY!

		GraphicsWidth@ VCGWidth!
		GraphicsHeight@ VCGHeight!
	end else
		GraphicsWidth@ 2 / twidth@ 2 / - VConsoleX!
		GraphicsHeight@ 2 / theight@ 2 / - VConsoleY!

		twidth@ VCGWidth!
		theight@ VCGHeight!
	end

	VConsoleBG VCColorBG!
	VConsoleFG VCColorFG!

	VCColorFG@ VCColorOFG!
	VCColorBG@ VCColorOBG!

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
	VConsoleX@ VConsoleY@
	VConsoleLongestLine 1 + VCWidth@ min
	VConsoleFontWidth * VCHeight@ VConsoleFontHeight * VConsoleBG VConsoleRect

	0 VCCurX!
	0 VCCurY!

	VCLineLenBuf@ VCHeight@ 4 * 0 memset
end

procedure VConsoleRect (* x y w h color -- *)
	GraphicsRectangle
end

procedure VConsoleBox (* x y w h color -- *)
	GraphicsLineRectangle
end

procedure VConsoleScroll (* rows -- *)
	auto rows
	rows!

	VConsoleX@ VConsoleY@
	VCGWidth@
	VCGHeight@ 1 +
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

procedure VConsoleUIBox (* title x y w h -- *)
	auto h
	h!

	auto w
	w!

	auto y
	y!

	auto x
	x!

	auto title
	title!

	x@ y@ w@ h@ 0x0F VConsoleRect
	x@ 1 + y@ 1 + w@ h@ 25 VConsoleRect
	x@ 1 + y@ 1 + w@ 1 - h@ 1 - 29 VConsoleRect
	x@ 10 + y@ 20 + w@ 18 - h@ 28 - 0x0F VConsoleRect
	x@ 10 + y@ 20 + w@ 19 - h@ 29 - 25 VConsoleRect
	x@ 11 + y@ 21 + w@ 21 - h@ 31 - 0x0F VConsoleRect
	x@ 12 + y@ 22 + w@ 22 - h@ 32 - 29 VConsoleRect

	auto tw
	title@ strlen VConsoleFontWidth * tw!

	title@ x@ w@ 2 / tw@ 2 / - + y@ 5 + 0 VConsoleRenderLine
end

procedure VConsoleDraw (* -- *)
	0 VCCurX!
	0 VCCurY!

	if (VConsoleX@ 0 ~= VConsoleY@ 0 ~= &&) (* there is at least VConsoleMargin/2 pixels around the edge, do a pretty box *)
		"AISIX System Console" VConsoleX@ 15 - VConsoleY@ 25 - VCGWidth@ 30 + VCGHeight@ 40 + VConsoleUIBox

		VConsoleX@ 4 - VConsoleY@ 4 - VCGWidth@ 10 + VCGHeight@ 10 + VConsoleBG VConsoleRect
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

	if (VCNeedsDraw@)
		VConsoleDraw
		0 VCNeedsDraw!
	end

	if (char@ 255 >)
		return
	end

	if (VCEscape@) char@ VConsoleParseEscape return end

	if (char@ 0x1b ==)
		pointerof VCEV0 VCEV!
		0 VCEV0!
		0 VCEV1!
		1 VCEscape!
		return
	end

	auto rs
	InterruptDisable rs!

	VConsoleClearCur

	char@ VConsolePutCharF

	VConsoleDrawCur

	rs@ InterruptRestore
end

procedure VConsolePutCharF (* char -- *)
	auto char
	char!

	if (char@ '\n' ==)
		VConsoleNewline
		return
	end else

	if (char@ '\b' ==)
		VConsoleBack
		return
	end else

	if (char@ '\t' ==)
		VConsoleTab
		return
	end

	end

	end

	VCCurX@ VConsoleFontWidth * VConsoleX@ +
	VCCurY@ VConsoleFontHeight * VConsoleY@ +
	char@
	VCColorFG@
	VConsoleDrawChar

	VCCurX@ 1 + VCCurX!

	if (VCCurX@ VCWidth@ >=)
		VConsoleNewline
	end
end

procedure VConsoleDrawChar (* x y char color -- *)
	auto color
	color!

	auto char
	char!

	auto y
	y!

	auto x
	x!

	x@ y@ char@ color@ VCColorBG@ VConsoleDrawFont
end

procedure VConsoleDrawFont (* x y char fgcolor bgcolor -- *)
	auto bg
	bg!

	auto fg
	fg!

	auto char
	char!

	auto y
	y!

	auto x
	x!

	(* dont draw spaces *)
	if (char@ ' ' ==)
		return
	end

	auto bmp
	char@ VConsoleFontBytesPerRow VConsoleFontHeight * * pointerof VConsoleFont + bmp!

	x@ y@ VConsoleFontWidth VConsoleFontHeight VConsoleFontBytesPerRow fg@ bg@ VConsoleFontBitD bmp@ GraphicsBlitBits
end

procedure VConsoleRenderLine (* line x y color -- *)
	auto color
	color!

	auto y
	y!

	auto x
	x!

	auto line
	line!

	auto i
	1 i!

	auto c
	line@ gb c!
	while (c@ 0 ~=)
		x@ y@ c@ color@ 0xFF VConsoleDrawFont

		x@ VConsoleFontWidth + x!
		line@ i@ + gb c!
		i@ 1 + i!
	end
end