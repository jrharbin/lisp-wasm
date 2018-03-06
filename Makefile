SOURCES=types.ml eval.ml main.ml
RESULT=lispwasm

-include OCamlMakefile

js: byte-code
	js_of_ocaml lispwasm

