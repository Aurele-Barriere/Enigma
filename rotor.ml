
module Map = Symbol.Map

type t = {
  name : string ;             (** Name, for printing. *)
  p : Symbol.sym Map.t ;      (** Permutation. *)
  p_inv : Symbol.sym Map.t ;  (** Inverse permutation. *)
  pos : Symbol.sym ;          (** Position of the rotor. *)
}

let image r x = Map.get r.p (Symbol.(++) r.pos x)
let pre_image r x = Symbol.(--) (Map.get r.p_inv x) r.pos

let step r = { r with pos = Symbol.next r.pos }

let rec steps r n = if n = 0 then r else step (steps r (n-1))

let notch r = r.pos = Symbol.a

let print chan rot =
  Printf.fprintf chan
    "%a[%s,pos=%d]"
    Map.print_tmap (Map.init (image rot))
    rot.name
    (Symbol.to_int rot.pos)

let name r = r.name

let to_string rot =
  Printf.sprintf "%s%02d" rot.name (Symbol.to_int rot.pos)

(** Create a rotor from a string that is assumed to describe
  * a permutation of symbols. *)
let of_string name perm =
  let p = Map.init (fun x -> Symbol.of_char perm.[Symbol.to_int x]) in
  let r =
    { name = name ;
      p = p ;
      p_inv = Map.inverse p ;
      pos = Symbol.a }
  in
    assert (Symbol.iter (fun s -> assert (image r (pre_image r s) = s)) ; true) ;
    r

let rotors = [
  of_string "A"   "EKMFLGDQVZNTOWYHXUSPAIBRCJ" ;
  of_string "B"  "AJDKSIRUXBLHWTMCQGZNPYFVOE" ;
  of_string "C" "BDFHJLCPRTXVZNYEIWGAKMUSQO" ;
  of_string "D"  "ESOVPZJAYQUIRHXLNFTGKDCMWB" ;
  of_string "E"   "VZBRGITYUPSDNHLXAWMJQOFECK" 
]
