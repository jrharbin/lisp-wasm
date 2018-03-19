open Types
open Eval

let denv = ref (setup_global_env ())
       
let e1 = List([Atom(Symbol(Named("+"))); (Atom(Number(Int(1)))); (Atom(Number(Int(2))))])
             (* let e2 = read "(+ 1 2)" *)

let test () = eval e1 [] !denv
(* Implement more test functions here *)
