%{
  open Ast
%}

%token SEMISEMI
%token PLUS MINUS TIMES DIVIDE LESS GREATER EQUAL NOTEQUAL
%token OR AND
%token IF THEN ELSE ENDIF
%token FOR DO DONE
%token LEFT_PAREN RIGHT_PAREN
%token SEMI
%token AVANCER RECULER DROITE GAUCHE
%token STOP DEBUT
%token <int> INT
%token <string> IDENT
%token TRUE FALSE
%token <float> FLOAT
%token EOF

%right SEMI
%left EQUAL GREATER LESS NOTEQUAL
%left PLUS MINUS OR
%left TIMES DIVIDE AND

%start main
%type <Ast.inst> main

%%

main: inst SEMISEMI EOF { $1 }

;



expr:
| arith_expr                                  { $1 }
| atom                                        { $1 }
;

arith_expr:
| arith_expr EQUAL arith_expr        { Binop("=", $1, $3) }
| arith_expr GREATER arith_expr      { Binop(">", $1, $3) }
| arith_expr LESS arith_expr         { Binop("<", $1, $3) }
| arith_expr PLUS arith_expr         { Binop("+", $1, $3) }
| arith_expr MINUS arith_expr        { Binop("-", $1, $3) }
| arith_expr TIMES arith_expr        { Binop("*", $1, $3) }
| arith_expr DIVIDE arith_expr       { Binop("/", $1, $3) }
;

inst:
  | IF expr THEN inst ELSE inst ENDIF    { If($2, $4, $6) }
  | FOR expr DO inst DONE                { For($2, $4) }
  |  STOP               { Stop }
  |  DEBUT              { Debut }
  |  AVANCER LEFT_PAREN INT RIGHT_PAREN  { Avancer(Int($3)) }
  |  RECULER LEFT_PAREN INT RIGHT_PAREN  { Reculer(Int($3)) }
  |  DROITE LEFT_PAREN INT RIGHT_PAREN  { Droite(Int($3)) }
  |  GAUCHE LEFT_PAREN INT RIGHT_PAREN  { Gauche(Int($3)) }
  | inst SEMI inst {Seq($1, $3)}
;

atom:
  INT            { Int($1) }
| TRUE           { Bool(true) }
| FALSE          { Bool(false) }
| IDENT          { Ident($1) }
| LEFT_PAREN expr RIGHT_PAREN { $2 }
;

