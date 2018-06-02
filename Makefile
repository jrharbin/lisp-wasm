SOURCES=types.ml print.ml specforms.ml eval.ml main.ml
PACKS=js_of_ocaml
RESULT=lispwasm

-include OCamlMakefile

js: byte-code
	js_of_ocaml lispwasm

