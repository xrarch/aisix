const AmaPortDev 0x30
const AmaPortMID 0x31
const AmaPortCMD 0x32
const AmaPortA 0x33
const AmaPortB 0x34
const AmaDevs 256

var AmanatsuDevices 0

var AmaLastInterrupt 0x80

buffer AmaInterruptMap 256

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

procedure AmanatsuEarlyInit (* -- *)
	"amanatsu: early init\n" Printf

	ListCreate AmanatsuDevices!
end

procedure AmanatsuDevRegister (* device -- *)
	AmanatsuDevices@ ListInsert
end

procedure AmanatsuSetInterrupt (* handler dev -- *)
	auto dev
	dev!

	auto handler
	handler!

	handler@ AmaLastInterrupt@ PBInterruptRegister
	AmaLastInterrupt@ dev@ 1 AmanatsuSpecialCMD

	dev@ AmaLastInterrupt@ AmaInterruptMap + sb

	AmaLastInterrupt@ 1 + AmaLastInterrupt!
end

procedure AmanatsuSpecialCMD (* a b cmd -- *)
	auto cmd
	cmd!

	auto b
	b!

	auto a
	a!

	0 AmanatsuSelectDev
	a@ AmanatsuWriteA
	b@ AmanatsuWriteB

	cmd@ AmanatsuCommand
end

procedure AmanatsuDoDevice (* did id -- *)
	auto id
	id!

	auto did
	did!

	auto n
	AmanatsuDevices@ ListHead n!

	while (n@ 0 ~=)
		auto pnode
		n@ ListNodeValue pnode!

		if (pnode@ AmanatsuDev_MID + @ id@ ==)
			pnode@ AmanatsuDev_Name + @ "%s" Printf

			did@ pnode@ AmanatsuDev_Constructor + @ Call

			break
		end

		n@ ListNode_Next + @ n!
	end
end

procedure AmanatsuLateInit (* -- *)
	"amanatsu: late init\n" Printf

	auto a
	1 a!

	"enumerating devices:\n" Printf

	while (a@ AmaDevs <)
		auto id
		a@ AmanatsuPoll id!

		if (id@ 0 ~=)
			a@ "\tamanatsu%d: " Printf

			a@ id@ AmanatsuDoDevice

			CR
		end

		a@ 1 + a!
	end
end