open Types

let print_symbol sym =
  match sym with
  | Named(s) -> Printf.sprintf "%s" s

let print_number n =
  match n with
  | Int(i) -> Printf.sprintf "%u" i
  | Float(f) -> Printf.sprintf "%.6f" f

let rec print_atom ?(str=stdout) a =
  match a with
    Symbol(s) -> print_symbol s
  | Number(n) -> print_number n
  | String(s) -> Printf.sprintf "%s" s
  | Closure(env,b,sexp) -> Printf.sprintf "#!CLOSURE %s" (print_sexp sexp)
  | CamlFn(desc,f) -> Printf.sprintf "#!INTERNAL-FUNC %s" desc
  | Nil -> Printf.sprintf "Nil"

and print_sexp s =
  match s with
    Atom(a) -> print_atom a
  | Quote(s) -> "'" ^ print_sexp s
  | Backquote(s) -> "`" ^ print_sexp s
  | Unquote(s) -> "," ^ print_sexp s
  | Lambda(b, sexp) -> "lambda"
  | List(sl) -> "(" ^ (List.fold_left (fun sofar s -> sofar ^ (print_sexp s)) "" sl) ^ ")"

let print = print_sexp
