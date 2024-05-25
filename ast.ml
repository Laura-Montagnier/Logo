type expr =
  | Binop of string * expr * expr
  | Unop of string * expr
  | Int of int
  | Bool of bool
  | Float of float
  | Ident of string

type inst =
  | If of expr * inst * inst
  | For of expr * inst
  | Reculer of expr
  | Avancer of expr
  | Droite of expr
  | Gauche of expr
  | Debut
  | Stop
  | Seq of inst * inst
