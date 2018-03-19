open Types

let specform_names = [
  "block";
  "catch";
  "eval-when";
  "flet";
  "function";
  "go";
  "if";
  "labels";
  "let";
  "let*";
  "load-time-value";
  "locally";
  "macrolet";
  "multiple-value-call";
  "multiple-value-prog1";
  "progn";
  "progv";
  "quote";
  "return-from";
  "setq";
  "symbol-macrolet";
  "tagbody";
  "the";
  "throw";
  "unwind-protect";
  "funcall";
  "block";
  "catch";
  "eval-when";
]

type special_forms = (string, unit) Hashtbl.t

let special_forms_from names =
  let h = Hashtbl.create 30
  in List.iter begin fun n ->
		     Hashtbl.add h n ()
	       end names;
     h

let special_forms = special_forms_from specform_names

let is_specform sym =
  match sym with
    Named(n) -> Hashtbl.mem special_forms n
