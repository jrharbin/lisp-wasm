open Types

module Env =
  struct
    type t = (symbol * expr) list
    let lookup ~id env = List.assoc id env
  end

let make_closure denv c exp = Nil
    
let rec eval denv e =
  match e with
  | Atom(Ident(id)) -> Env.lookup ~id denv
  | Cons(c,e) -> Cons((eval denv c), (eval denv c))
  | Lambda(c,exp) -> make_closure denv c exp
  | _ -> e
