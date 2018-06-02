JSFLAGS = -use-menhir -menhir "menhir --explain" -use-ocamlfind -plugin-tag "package(js_of_ocaml.ocamlbuild)"
FLAGS = $(JSFLAGS) -libs unix
OCAMLBUILD ?= ocamlbuild

.PHONY: serve clean repl.js lambda.native

default: lispwasm.js

_build/repl.js:
	$(OCAMLBUILD) $(JSFLAGS) src/lispwasm.js

lambda.native:
	$(OCAMLBUILD) $(FLAGS) src/lambda.native

repl.js: _build/repl.js
	ln -fs _build/src/repl.js .

clean:
	$(OCAMLBUILD) -clean
