type symbol = string
type id = string

type params = symbol list

type atom =
  | Int of int
  | Ident of id
  | Float of float
  | Sym of symbol
		     
type expr =
  | Nil
  | Atom of atom
  | Cons of expr * expr
  | Lambda of params * expr
