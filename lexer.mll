{
 open Parser ;;
 exception Eof ;;
}

rule read =
  parse
  | "+"       { PLUS }
  | "-"       { MINUS }
  | "*"       { TIMES }
  | "/"       { DIVIDE }
  | "||"      { OR }
  | "&&"      { AND }
  | "<"       { LESS }
  | ">"       { GREATER }
  | "=="      { EQUAL }
  | "!="      { NOTEQUAL }
  | "si"      { IF }
  | "alors"   { THEN }
  | "sinon"   { ELSE }
  | "pour"    { FOR }
  | "faire"   { DO }
  | "fini"    { DONE }
  | '('       { LEFT_PAREN }
  | ')'       { RIGHT_PAREN }
  | "avancer" { AVANCER }
  | "reculer" { RECULER }
  | "tourner_droite" { DROITE }
  | "tourner_gauche" { GAUCHE }
  | "stop_tracer" { STOP }
  | "debut_tracer" { DEBUT }
  | ['a'-'z' 'A'-'Z']+ as id { IDENT(id) }
  | ['0'-'9']+ as num { INT(int_of_string num) }
  | ['0'-'9']+ '.' ['0'-'9']+ as fnum { FLOAT(float_of_string fnum) }
  | ";" { SEMI }
  | ";;" { SEMISEMI }
  | eof       { EOF }
  | _         { raise Eof }
