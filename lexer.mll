rule read = parse
  | [' ' '\t' '\r' '\n'] { Printf.printf "Whitespace\n"; read lexbuf }  (* Capture des espaces blancs *)
  | ";;" { Printf.printf "SEMISEMI\n"; SEMISEMI }
  | "+" { Printf.printf "PLUS\n"; PLUS }
  | "-" { Printf.printf "MINUS\n"; MINUS }
  | "*" { Printf.printf "TIMES\n"; TIMES }
  | "/" { Printf.printf "DIVIDE\n"; DIVIDE }
  | "<" { Printf.printf "LESS\n"; LESS }
  | ">" { Printf.printf "GREATER\n"; GREATER }
  | "=" { Printf.printf "EQUAL\n"; EQUAL }
  | "!=" { Printf.printf "NOTEQUAL\n"; NOTEQUAL }
  | "||" { Printf.printf "OR\n"; OR }
  | "&&" { Printf.printf "AND\n"; AND }
  | "if" { Printf.printf "IF\n"; IF }
  | "then" { Printf.printf "THEN\n"; THEN }
  | "else" { Printf.printf "ELSE\n"; ELSE }
  | "endif" { Printf.printf "ENDIF\n"; ENDIF }
  | "for" { Printf.printf "FOR\n"; FOR }
  | "do" { Printf.printf "DO\n"; DO }
  | "done" { Printf.printf "DONE\n"; DONE }
  | "(" { Printf.printf "LEFT_PAREN\n"; LEFT_PAREN }
  | ")" { Printf.printf "RIGHT_PAREN\n"; RIGHT_PAREN }
  | ";" { Printf.printf "SEMI\n"; SEMI }
  | "avancer" { Printf.printf "AVANCER\n"; AVANCER }
  | "reculer" { Printf.printf "RECULER\n"; RECULER }
  | "droite" { Printf.printf "DROITE\n"; DROITE }
  | "gauche" { Printf.printf "GAUCHE\n"; GAUCHE }
  | "stop" { Printf.printf "STOP\n"; STOP }
  | "debut" { Printf.printf "DEBUT\n"; DEBUT }
  | ['0'-'9']+ as lxm { Printf.printf "INT(%s)\n" lxm; INT (int_of_string lxm) }
  | ['0'-'9']+ '.' ['0'-'9']* as lxm { Printf.printf "FLOAT(%s)\n" lxm; FLOAT (float_of_string lxm) }
  | ['a'-'z' 'A'-'Z' '_'] ['a'-'z' 'A'-'Z' '0'-'9' '_']* as lxm { Printf.printf "IDENT(%s)\n" lxm; IDENT lxm }
  | eof { Printf.printf "EOF\n"; EOF }
  | _ as c { failwith ("Unexpected character: " ^ (String.escaped (String.make 1 c))) }

