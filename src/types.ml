type num = Int of int
         | Float of float

type sym = Named of string
                  
type atom = Symbol of sym
          | Number of num
          | String of string
          | Closure of env * bindings * sexp
          | CamlFn of string * (sexp list -> atom)
          | Nil
                       
and bindings = sym list
                     
and sexp = Atom of atom
         | Quote of sexp
         | Backquote of sexp
         | Unquote of sexp
         | Lambda of bindings * sexp
         | List of sexp list

and env = (sym * atom) list

exception IllegalCall of sexp list
exception TooManyArguments
exception UndefinedFunction of sym
exception TypeError of string
exception NotAFunction of sym
exception NotAFunction2 of atom
