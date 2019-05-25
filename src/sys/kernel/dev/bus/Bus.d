#include "dev/bus/EBus.d"
#include "dev/bus/Citron.d"
#include "dev/bus/Amanatsu.d"
#include "dev/bus/DMA.d"

procedure BusInit (* -- *)
	"bus: init\n" Printf

	EBusInit
	AmanatsuInit
	DMAInit
end

procedure BusProbe (* -- *)
	"bus: probing buses\n" Printf

	EBusProbe
	AmanatsuProbe
end