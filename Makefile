SOURCES=src/types.ml src/print.ml src/specforms.ml src/eval.ml src/main.ml
PACKS=js_of_ocaml js_of_ocaml-ppx
RESULT=lispwasm

-include OCamlMakefile

js: byte-code
	js_of_ocaml lispwasm
