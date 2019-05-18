const AmaPortDev 0x30
const AmaPortMID 0x31
const AmaPortCMD 0x32
const AmaPortA 0x33
const AmaPortB 0x34
const AmaDevs 256

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