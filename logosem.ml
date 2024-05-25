open Ast;;
open Graphics;;


type vals =
  | V_int of int
  | V_Bool of bool
  | V_float of float
  | V_string of string
;;


type turtle_state = {
  mutable x: float;
  mutable y: float;
  mutable angle: float;
  mutable pen_down: bool;
} ;;

let initial_state = {
  x = 0.0;
  y = 0.0;
  angle = 0.0;
  pen_down = true;
} ;;


(* Ast.expr -> val *)
let rec eval_expr = function
  | Ast.Int i -> V_int i
  | Ast.Bool b -> V_Bool b
  | Ast.Ident s -> V_string s
  | Ast.Float f -> V_float f
  | _ -> failwith "eval des opérandes puis opération qui va bien"
;;


let rec eval_instruction instr state =
  match instr with
  | Avancer d_expr -> (
      match eval_expr d_expr with
      | V_Bool _ -> Printf.printf "Oh que c'est mal typé.\n"
      | V_string _ -> Printf.printf "Trop bizarre.\n"
      | V_float f ->
          let distance = f in
          let rad = state.angle *. (Float.pi /. 180.0) in
          let new_x = state.x +. (distance *. cos rad) in
          let new_y = state.y +. (distance *. sin rad) in
          if state.pen_down then begin
            Printf.printf "Dessiner de (%.2f, %.2f) à (%.2f, %.2f)\n" state.x state.y new_x new_y;
            Graphics.lineto (int_of_float new_x) (int_of_float new_y)
          end
          else Graphics.moveto (int_of_float new_x) (int_of_float new_y);
          state.x <- new_x;
          state.y <- new_y
      | V_int i ->
          let distance = float_of_int i in
          let rad = state.angle *. (Float.pi /. 180.0) in
          let new_x = state.x +. (distance *. cos rad) in
          let new_y = state.y +. (distance *. sin rad) in
          if state.pen_down then begin
            Printf.printf "Dessiner de (%.2f, %.2f) à (%.2f, %.2f)\n" state.x state.y new_x new_y;
            Graphics.lineto (int_of_float new_x) (int_of_float new_y)
          end
          else Graphics.moveto (int_of_float new_x) (int_of_float new_y);
          state.x <- new_x;
          state.y <- new_y
     )
  | Reculer d_expr -> (
    match eval_expr d_expr with
    |V_Bool _ -> Printf.printf "Mal typé. \n"
    |V_string _ -> Printf.printf "Trop bizarre et trop mal typé. \n"
    | V_float f ->
          let distance = f in
          let rad = state.angle *. (Float.pi /. 180.0) in
          let new_x = state.x +. (distance *. (-1.0) *. cos rad) in
          let new_y = state.y +. (distance *. (-1.0) *. sin rad) in
          if state.pen_down then begin
            Printf.printf "Dessiner de (%.2f, %.2f) à (%.2f, %.2f)\n" state.x state.y new_x new_y;
            Graphics.lineto (int_of_float new_x) (int_of_float new_y)
          end else
            Graphics.moveto (int_of_float new_x) (int_of_float new_y);
          state.x <- new_x;
          state.y <- new_y
    |V_int i ->
      let distance = float_of_int i in
      let rad = state.angle *. (Float.pi /. 180.0) in
      let new_x = state.x +. (distance *. (-1.0) *. cos rad) in
      let new_y = state.y +. (distance *. (-1.0) *. sin rad) in
      if state.pen_down then begin
        Printf.printf "Dessiner de (%.2f, %.2f) à (%.2f, %.2f)\n" state.x state.y new_x new_y;
        Graphics.lineto (int_of_float new_x) (int_of_float new_y)
      end else
        Graphics.moveto (int_of_float new_x) (int_of_float new_y);
      state.x <- new_x;
      state.y <- new_y
    )
  | Droite angle_expr -> (
    match eval_expr angle_expr with
    |V_Bool _ -> Printf.printf "Mal typé. \n"
    |V_string _ -> Printf.printf "Trop bizarre et trop mal typé. \n"
    |V_int i ->
    let angle = float_of_int i in
      state.angle <- state.angle -. angle
    |V_float f ->
    let angle = f in
      state.angle <- state.angle -. angle
  )
  | Gauche angle_expr -> (
    match eval_expr angle_expr with
    |V_Bool _ -> Printf.printf "Mal typé. \n"
    |V_string _ -> Printf.printf "Trop bizarre et trop mal typé. \n"
    |V_int i ->
    let angle = float_of_int i in
      state.angle <- state.angle +. angle
    |V_float f ->
    let angle = f in
      state.angle <- state.angle +. angle
  )
  | If (e, i1, i2) -> (
      match eval_expr e with
      | V_Bool b ->
          if b then eval_instruction i1 state else eval_instruction i2 state
      | _ -> failwith "Mauvais typage pour if"
    )
  | For (count_expr, instr) -> (
      match eval_expr count_expr with
      | V_int count ->
          for _ = 1 to count do
            eval_instruction instr state
          done
      | _ -> failwith "Une boucle doit se faire sur un nombre entier"
      )
  | Ast.Debut -> state.pen_down <- true
  | Ast.Stop  -> state.pen_down <- false
  | Ast.Seq (i1, i2) -> 
      eval_instruction i1 state;
      eval_instruction i2 state



