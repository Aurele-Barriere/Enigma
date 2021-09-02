(** Implementation of (a common flavour of) Enigma machines. *)

module Map = Symbol.Map

type machine = {
  plugboard : Involution.t ;
  rot_1 : Rotor.t ;
  rot_2 : Rotor.t ;
  rot_3 : Rotor.t ;
  reflector : Involution.t ;
}

let image {plugboard;reflector;rot_1;rot_2;rot_3} s =
  let (>=) x f = Map.get f x in
  let (>+) x r = Rotor.image r x in
  let (>-) x r = Rotor.pre_image r x in
    let r =
      s >= plugboard
        >+ rot_1 >+ rot_2 >+rot_3
        >= reflector
        >- rot_3 >- rot_2 >- rot_1
        >= plugboard
    in
      r

let step ({rot_1;rot_2;rot_3;_} as m) =
  let rot_1 = Rotor.step rot_1 in
  let rot_2 = if Rotor.notch rot_1 then Rotor.step rot_2 else rot_2 in
  let rot_3 =
    if Rotor.notch rot_1 && Rotor.notch rot_2 then
      Rotor.step rot_3
    else
      rot_3
  in
    { m with rot_1 = rot_1 ; rot_2 = rot_2 ; rot_3 = rot_3 }

(** Run the machine on a string.
  * Returns the machine in its new state after translating the string,
  * together with the translated string. *)
let translate m input =
  let cipher = Bytes.make (String.length input) '?' in
  let rec translate i m =
    if i = String.length input then m else begin
      Bytes.set cipher i
        (Symbol.to_char (image m (Symbol.of_char input.[i]))) ;
      translate (i+1) (step m)
    end
  in
  let m = translate 0 m in
    m, (Bytes.to_string cipher)

(** Machine for tests. *)
let test =
  match Rotor.rotors with
    | [s;_;t;r;_] ->
        {
          plugboard = Involution.default_plugboard ;
          rot_1 = Rotor.steps r 7 ;
          rot_2 = Rotor.steps s 19 ;
          rot_3 = Rotor.steps t 0 ;
          reflector = Involution.reflector
        }
    | _ -> assert false

(** Show the full configuration of a machine. *)
let print chan {plugboard;rot_1;rot_2;rot_3;reflector} =
  Printf.fprintf chan
    ".... %a\nplug %a\nrot1 %a\nrot2 %a\nrot3 %a\nrefl %a\n"
    Map.print_tmap (Map.init (fun x -> x))
    Map.print_tmap plugboard
    Rotor.print rot_1
    Rotor.print rot_2
    Rotor.print rot_3
    Map.print_tmap reflector

(** Short description of a machine. *)
let to_string m =
  assert (m.reflector = Involution.reflector) ;
  let base =
    Printf.sprintf
      "%s-%s-%s"
      (Rotor.to_string m.rot_1)
      (Rotor.to_string m.rot_2)
      (Rotor.to_string m.rot_3)
  in
    if m.plugboard = Involution.default_plugboard then base else
      base ^ "-" ^ Involution.to_string m.plugboard

(** Show two strings of the same length (a priori, a plaintext
  * and its cipher) together with some indices to help debugging. *)
let print_known_cipher ~clear ~cipher =
  Printf.printf "        " ;
  for i = 0 to String.length clear - 1 do
    print_int ((i / 10) mod 10)
  done ;
  Printf.printf "\n" ;
  Printf.printf "        " ;
  for i = 0 to String.length clear - 1 do
    print_int (i mod 10)
  done ;
  Printf.printf "\n" ;
  Printf.printf "Clear : %s.\nCipher: %s.\n%!" clear cipher

(** Behaviour of the "enigma" executable. *)
let () =
  if Filename.basename Sys.argv.(0) = "enigma" then begin

    let rec run m args =
      Printf.printf "Using machine %s:\n%a\n" (to_string m) print m ;
      let clear,args = match args with
        | arg::args ->
            Printf.printf "Translating command-line argument...\n" ;
            arg,args
        | [] ->
            Printf.printf "Type your text, or Ctrl-D to exit: %!" ;
            input_line stdin, args
      in
      let clear = String.uppercase clear in
      let m, cipher = translate m clear in
        Printf.printf "\n" ;
        print_known_cipher ~clear ~cipher ;
        Printf.printf "\n%!" ;
        run m args
    in
      try run test (List.tl (Array.to_list Sys.argv)) with End_of_file -> Printf.printf "\n"

  end
