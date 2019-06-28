table aisixfatFS
	pointerof aisixfatReadSuper
	"aisixfat"
	1
endtable

table aisixfatSuperOps
	pointerof aisixfatReadVnode
	pointerof aisixfatWriteVnode
	pointerof aisixfatPutVnode
	pointerof aisixfatPutSuper
	0
	pointerof aisixfatStatFS
	pointerof aisixfatRemountFS
endtable

procedure aisixfatInit (* -- *)
	aisixfatFS VFSRegister
end

procedure aisixfatReadSuper (* data sb -- success? *)
	auto sb
	sb!

	auto data
	data!

	0
end

procedure aisixfatPutSuper (* sb -- err *)
	auto sb
	sb!

	0
end

procedure aisixfatStatFS (* -- *)

end

procedure aisixfatRemountFS (* -- *)

end