(** Enigma rotors. *)

type t

(** Image of a symbol by the underlying permutation. *)
val image : t -> Symbol.sym -> Symbol.sym

(** Pre-computed inverse of the previous function. *)
val pre_image : t -> Symbol.sym -> Symbol.sym

(** Compute the rotor rotated by one step. *)
val step : t -> t

(** Same but for an arbitrary (positive) number of steps. *)
val steps : t -> int -> t

(** See if the rotor is in a position where its
  * notch will trigger the rotation of the next rotor. *)
val notch : t -> bool

(** Name of a rotor. Does not take position into account. *)
val name : t -> string

(** Print the contents of the rotor. *)
val print : out_channel -> t -> unit

(** Return a string that is a short description of the rotor. *)
val to_string : t -> string

(** List of "official" rotors, the only ones that may be used
  * in practice. *)
val rotors : t list
