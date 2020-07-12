const DCitronBase 0xF8000000

extern DCitronInb { port -- byte }

extern DCitronIni { port -- int }

extern DCitronInl { port -- long }

extern DCitronOutb { byte port -- }

extern DCitronOuti { int port -- }

extern DCitronOutl { long port -- }

extern DCitronCommand { command port -- }

(* doesn't wait for the device to report the operation as completed before returning *)
extern DCitronCommandASync { command port -- }