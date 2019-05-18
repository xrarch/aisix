(* aisix graphics subsystem

only supports 1 screen right now

*)

var GraphicsWidth 0
var GraphicsHeight 0
var GraphicsPresent 0
var GraphicsFramebuffer 0

#include "dev/graphics/Kinnow3.d"
#include "dev/graphics/VidConsole.d"

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

procedure GraphicsEarlyInit (* -- *)
	"graphics: early init\n" Printf

	Kinnow3Init
end

procedure GraphicsLateInit (* -- *)
	"graphics: late init\n" Printf

	if (KinnowSlotSpace@ 0 ~=)
		1 GraphicsPresent!

		KinnowWidth@ GraphicsWidth!
		KinnowHeight@ GraphicsHeight!
		KinnowFBStart@ GraphicsFramebuffer!

		VidConInit
	end
end