(** Constrained plugboards. *)

(* --- Section 5.1 --- *)

type t

(** Basic interface *)

val top : unit -> t

(** Prints a constrained board  *)
val print : long:bool -> out_channel -> t -> unit

(** Indicates whether an association is possible in a given constrained board. *)
val possible : t -> Symbol.sym -> Symbol.sym -> bool

(** Returns the list of all currently possible associations for a given
  * symbol in a constrained board. *)
val possibles : t -> Symbol.sym -> Symbol.sym list

exception Impossible

(** [remove_assoc p x y] updates the constraints of [p] to reflect
  * the fact that [x] and [y] cannot be associated in it.
  * If an inconsistency is detected, [Impossible] is raised. *)
val remove_assoc : t -> Symbol.sym -> Symbol.sym -> unit

(* --- Section 5.2 --- *)

(** Semi-persistency *)

(** Abstract representation of the state of a board. *)
type state

(** Returns the current state of a board. This should be immediate. *)
val save : t -> state

(** Restore a board to one of its previous states. The board that
  * should be restored is implicit in the state. *)
val restore : state -> unit
