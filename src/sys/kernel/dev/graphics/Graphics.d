(* aisix graphics subsystem

only supports 1 screen right now

*)

var GraphicsWidth 0
var GraphicsHeight 0
var GraphicsPresent 0
var GraphicsFramebuffer 0

#include "dev/graphics/Kinnow3.d"
procedure GraphicsRectangle (* x y w h color -- *)
	if (GraphicsPresent@)
		KinnowRectangle
	end else
		drop drop drop drop drop
	end
end

procedure GraphicsBlit (* x y w h bmp ignore -- *)
	if (GraphicsPresent@)
		KinnowBlit
	end else
		drop drop drop drop drop drop
	end
end

procedure GraphicsBlitBack (* x y w h bmp -- *)
	if (GraphicsPresent@)
		KinnowBlitBack
	end else
		drop drop drop drop drop
	end
end

procedure GraphicsScroll (* x y w h color rows -- *)
	if (GraphicsPresent@)
		KinnowScroll
	end else
		drop drop drop drop drop drop
	end
end

procedure GraphicsS2S (* x1 y1 x2 y2 w h -- *)
	if (GraphicsPresent@)
		KinnowBlitS2S
	end else
		drop drop drop drop drop drop
	end
end

procedure GraphicsBlitBits (* x y w h bpr fg bg bitd bmp -- *)
	if (GraphicsPresent@)
		KinnowBlitBits
	end else
		drop drop drop drop drop drop drop drop
	end
end

procedure GraphicsLateInit (* -- *)
	"graphics: late init\n" Printf

	if ("-nographics" ArgsCheck)
		"graphics: -nographics, aborting\n" Printf
		return
	end

	if (KinnowSlotSpace@ 0 ~=)
		1 GraphicsPresent!

		KinnowWidth@ GraphicsWidth!
		KinnowHeight@ GraphicsHeight!
		KinnowFBStart@ GraphicsFramebuffer!
	end

	if (GraphicsPresent@)
		if ("-graphics,noclear" ArgsCheck ~~)
			0 0 GraphicsWidth@ GraphicsHeight@ 25 GraphicsRectangle
		end
	end
end

procedure GraphicsInit (* -- *)
	"graphics: init\n" Printf

	if ("-nographics" ArgsCheck)
		"graphics: -nographics, aborting\n" Printf
		return
	end

	Kinnow3Init
end