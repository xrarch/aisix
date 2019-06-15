#include "dev/limnstation/bus/EBus.d"
#include "dev/limnstation/bus/Citron.d"
#include "dev/limnstation/bus/Amanatsu.d"
#include "dev/limnstation/bus/DMA.d"

procedure BusInit (* -- *)
	EBusInit
	AmanatsuInit
	DMAInit
end

procedure BusProbe (* -- *)
	EBusProbe
	AmanatsuProbe
end