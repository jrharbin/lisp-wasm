open Types

module Env =
  struct
    type t = env
    let lookup_function ~name env =
      try
	let a = List.assoc name env
	in 
	match a with
	  Closure(_) -> a
	| CamlFn(_) -> a
	| _ -> raise (NotAFunction name)
      with Not_found -> raise (UndefinedFunction name)
			      
    let rec make_bindings (env : env) names cdr =
      match (names,cdr) with
      | ([], []) -> env
      | ((n::ns), ((Atom a)::ad)) -> make_bindings ((n,a)::env) ns ad
      | _ -> raise TooManyArguments  
  end

let names_specform s =
  match s with
    Named("if") -> true
  | Named("funcall") -> true
  | _ -> false
    
let rec eval_specform e senv denv = e

and eval_fcall name (cdr : sexp list) (senv:env) (denv:env) =
  let f = Env.lookup_function name denv
  in match f with
     | Closure(fenv, b, exp) -> eval exp (Env.make_bindings (fenv @ senv) b cdr) denv
     | CamlFn(n, f) -> Atom (f cdr)
     | _ -> raise (NotAFunction2 f)

and eval_backquote e = e
    
and eval (e : sexp) (senv:env) (denv : env) =
  match e with
  | Quote(e1) -> e1
  | Backquote(e) -> eval_backquote e
  | Lambda(b, sexp) -> (Atom(Closure(senv, b, sexp)))
  | Unquote(e1) -> eval e1 senv denv
  | List([]) -> (Atom(Nil))
  | List(el) ->
     let car = List.hd el
     and cdrs = List.tl el
     in 
     begin match car with
     | Atom(Symbol(s)) -> if names_specform s then
                                   eval_specform e senv denv
                                 else
                                   let cdrs = (List.map (fun c -> eval c senv denv) cdrs)
                                               in eval_fcall s cdrs senv denv
     | _ -> e
     end
  | _ -> e

let internal_arith2 fname f alist =
  match alist with
  | [Atom(Number(Int(i1))); Atom(Number(Int(i2)))] -> Number(Int(f i1 i2))
  | _ -> raise (TypeError (Printf.sprintf "%s" fname))

let make_internal_arith2 fname f =
  CamlFn(fname, (internal_arith2 fname f))
	       
let initial_global_env () =
  [ Named("+"), (make_internal_arith2 "internal_plus2"  ( + ));
    Named("-"), (make_internal_arith2 "internal_minus2" ( - ));
    Named("*"), (make_internal_arith2 "internal_mult2"  ( * ));
    Named("/"), (make_internal_arith2 "internal_div2"   ( / )) ]

