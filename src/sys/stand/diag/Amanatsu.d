#include "<df>/dragonfruit.h"

#include "citron.h"

const AmaPortDev 0x30
const AmaPortMID 0x31
const AmaPortCMD 0x32
const AmaPortA 0x33
const AmaPortB 0x34
const AmaDevs 256

const AmaIDN 3
table AmaIDs
	0x00000000 "EMPTY"
	0x4D4F5553 "AISA Mouse"
	0x8FC48FC4 "AISA Keyboard"
endtable

(* disabling and restoring interrupts is up to the user of these functions *)

procedure AmanatsuPoll (* num -- mid *)
	AmanatsuSelectDev AmanatsuReadMID
end

procedure AmanatsuSelectDev (* num -- *)
	AmaPortDev DCitronOutb
end

procedure AmanatsuReadMID (* -- mid *)
	AmaPortMID DCitronInl
end

procedure AmanatsuCommand (* cmd -- *)
	AmaPortCMD DCitronOutl

	while (AmaPortCMD DCitronInl 0 ~=) end
end

procedure AmanatsuCommandAsync (* cmd -- *)
	AmaPortCMD DCitronOutl
end

procedure AmanatsuWriteA (* long -- *)
	AmaPortA DCitronOutl
end

procedure AmanatsuWriteB (* long -- *)
	AmaPortB DCitronOutl
end

procedure AmanatsuReadA (* -- long *)
	AmaPortA DCitronInl
end

procedure AmanatsuReadB (* -- long *)
	AmaPortB DCitronInl
end

procedure AmanatsuIDtoLabel (* id -- label *)
	auto id
	id!

	auto i
	0 i!

	auto p
	AmaIDs p!

	while (i@ AmaIDN <)
		if (p@ @ id@ ==)
			p@ 4 + @ return
		end

		p@ 8 + p!
		i@ 1 + i!
	end

	"unknown"
end

procedure AmanatsuDump (* -- *)
	auto i
	1 i!

	"== amanatsu dump ==\n\tSLOT\tMID\t\tTYPE\n" Printf

	"\t0\t00000000\tCONTROLLER\n" Printf

	while (i@ AmaDevs <)
		auto mid
		i@ AmanatsuPoll mid!

		if (mid@ 0 ~=)
			mid@ AmanatsuIDtoLabel mid@ i@ "\t%d\t%x\t%s\n" Printf
		end

		i@ 1 + i!
	end

	CR
end