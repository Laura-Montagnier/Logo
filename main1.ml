open Graphics;;
open Logosem;;
open Lexer;;
open Parser;;

let main () =
  (* Initialisation de la fenêtre graphique *)
  open_graph " 800x600";

  
  (* Exemple de séquence d'instructions à évaluer *)
    let instructions = 
    Ast.Seq (
      Avancer (Ast.Int 50),
      Seq (
        Gauche (Ast.Int 90),
        Seq (
          Avancer (Ast.Int 100),
          Seq (
            If (Ast.Bool true, Gauche (Ast.Int 50), Avancer (Ast.Int 200)),
            For (Ast.Int 3, Avancer (Ast.Int 50))
          )
        )
      )
    )
  in
  
  (* Création de l'état initial de la tortue *)
  let state = initial_state in
  (* Évaluation des instructions *)
  eval_instruction instructions state;
  
  (* Attendre que l'utilisateur ferme la fenêtre *)
  try
    while true do
      if button_down () then
        let _ = wait_next_event [Button_up] in ()
      else
        let _ = wait_next_event [Key_pressed] in ()
    done
  with
  | Graphic_failure _ -> close_graph (); exit 0
;;

(* Appel de la fonction main *)
main ()

