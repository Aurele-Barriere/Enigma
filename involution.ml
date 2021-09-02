(** Involutive permutations. *)

module Map = Symbol.Map

type t = Symbol.sym Map.t

let image i x = Map.get i x

(** Assume that s describes an involution. *)
let of_string s =
  let i =
    Map.init (fun x -> Symbol.of_char s.[Symbol.to_int x])
  in
    assert (Symbol.iter (fun s -> assert (image i (image i s) = s)) ; true) ;
    i

let to_bytes m =
  let s = Bytes.make Symbol.nb_syms '?' in
    Symbol.iter
      (fun i ->
         s.[Symbol.to_int i] <-
           Symbol.to_char (Map.get m i)) ;
    s
    
let to_string m =
   (Bytes.to_string (to_bytes m))

(** We assume the following fixed reflector.
  * It has the property that no symbol is mapped to itself;
  * this property carries over to the whole Enigma cipher. *)
let reflector = of_string "EJMZALYXVBWFCRQUONTSPIKHGD"

(** Other reflectors used in some versions of Enigma:
let refl_b = of_string "YRUHQSLDPXNGOKMIEBFZCWVJAT"
let refl_c = of_string "FVPJIAOYEDRZXWGCTKUQSBNMHL" *)

let default_plugboard =
  let m = Map.init (fun i -> i) in
  let swap a b =
    assert (Map.get m a = a) ;
    assert (Map.get m b = b) ;
    Map.set m b a ; Map.set m a b
  in
    List.iter
      (fun (a,b) -> swap (Symbol.of_char a) (Symbol.of_char b))
      ['A','D'; 'B','Z'; 'C','E'; 'F','N'; 'M','V'; 'O','Q'; 'P','S'; 'U','X'] ;
    m
