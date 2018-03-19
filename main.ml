open Types
open Eval

let denv = ref (initial_global_env ())
       
let e1 = List([Atom(Symbol(Named("-"))); (Atom(Number(Int(1)))); (Atom(Number(Int(2))))])
             (* let e2 = read "(+ 1 2)" *)

let test () =
  let res = eval e1 [] !denv
  in Printf.printf "Sexp = %s, result = %s\n" (Print.print_sexp e1) (Print.print_sexp res)
  (* Implement more test functions here *)

let _ = test ()
