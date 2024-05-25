open Graphics;;
open Logosem;;
open Lexer;;
open Parser;;


let run_program program_string =
  (* Analyse syntaxique (parsing) *)
  let lexbuf = Lexing.from_string program_string in
  let ast = Parser.main Lexer.read lexbuf in

  (* Boucle d'interprétation *)
  let initial_state = { x = 0.0; y = 0.0; angle = 0.0; pen_down = true } in
  eval_instruction ast initial_state

let read_file file_path =
  let ic = open_in file_path in
  let content = really_input_string ic (in_channel_length ic) in
  close_in ic;
  content

let rec read_program () =
  print_endline "Entrez le chemin vers le fichier contenant votre programme (ou entrez 'exit' pour quitter) :";
  let file_path = read_line () in
  if file_path = "exit" then
    ()
  else begin
    (* Lire le contenu du fichier *)
    try
      let program_string = read_file file_path in
      (* Exécuter le programme *)
      run_program program_string;
      (* Lire le programme suivant récursivement *)
      read_program ()
    with
    | Sys_error msg -> print_endline ("Erreur lors de la lecture du fichier : " ^ msg);
                       read_program ()
  end


let () =
  (* Lire et exécuter les programmes jusqu'à ce que l'utilisateur entre 'exit' *)
  read_program ()