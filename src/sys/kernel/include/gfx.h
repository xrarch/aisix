const MAXGFX 16

struct GFX
	4 Width
	4 Height
	4 Depth
	4 FBAddr
	4 FBSize
	4 VRAM
	4 VRAMSize
	4 Unit
	4 UData

	4 Rect
	4 BlitBits
	4 Blit
	4 Scroll
	4 Invert
endstruct

fnptr GFXRect { x y w h color gfx -- }

fnptr GFXBlitBits { bpr fg bg bitd ptr x y w h gfx -- }

fnptr GFXBlit { x y w h ptr gfx -- }

fnptr GFXScroll { x y w h color rows gfx -- }

fnptr GFXInvert { x y w h gfx -- }

extern AllocGFX { -- gfx }

extern GFXRegister { gfx -- }

extern GFXByUnit { unit -- gfx }