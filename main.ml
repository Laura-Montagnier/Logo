open Graphics;;
open Logosem;;
open Lexer;;
open Parser;;

let run_program in_channel =
  (* Ouvrir la fenêtre graphique après l'exécution du programme *)
  open_graph " 800x600";
  (* Analyse syntaxique (parsing) *)
  let lexbuf = Lexing.from_channel in_channel in
  while true do
    try
      Printf.printf "Parsing...\n"; (* Ajouté pour le débogage *)
      let ast = Parser.main Lexer.read lexbuf in
      Printf.printf "Parsing réussi.\n"; (* Ajouté pour le débogage *)
      (* Création de l'état initial de la tortue *)
      let state = initial_state in
      (* Évaluation des instructions *)
      eval_instruction ast state;
      Printf.printf "Instruction évaluée.\n"; (* Ajouté pour le débogage *)
      (* Actualiser l'affichage graphique *)
      synchronize ();
    with
    | Lexer.Eof ->
        Printf.printf "Fin du fichier atteinte.\n";
        close_graph ();
        exit 0
    | Failure msg ->
        Printf.printf "Erreur de lexer : %s\n" msg;
        close_graph ();
        exit 0
    | Parsing.Parse_error ->
        let pos = lexbuf.Lexing.lex_curr_p in
        let line = pos.Lexing.pos_lnum in
        let col = pos.Lexing.pos_cnum - pos.Lexing.pos_bol in
        Printf.printf "Erreur de parsing à la ligne %d, colonne %d\n" line col;
        close_graph ();
        exit 1
    | Graphic_failure _ ->
        Printf.printf "La graphics a foiré.\n";
        close_graph ();
        exit 1
    | e ->
        Printf.printf "Erreur inconnue : %s\n" (Printexc.to_string e);
        close_graph ();
        exit 1
  done
;;


let main () =
  let in_channel =
    match Array.length Sys.argv with
    | 1 -> stdin
    | 2 -> (
        match Sys.argv.(1) with
        | "-" -> stdin
        | name ->
            (try open_in name with
            |_ -> Printf.eprintf "Echec ouverture %s\n%!" name ; exit 1)
       )
    | n ->
        Printf.printf "Trop d'arguments sur la ligne de commande.\n" ;
        exit 1 in
  run_program in_channel
;;


(* Appel de la fonction main *)
main () ;;



