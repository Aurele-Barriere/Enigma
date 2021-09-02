(** Efficient representation of paths, as a utility for the computation of
  * all cycles of a graph. *)

type t

(** This compare function describes an order over all paths *)
(* [compare x y] returns 0 if x is equal to y, a negative integer if x is less than y, and a positive integer if x is greater than y *)
(* You may need such a function, for instance to use the Set module from the standard library on paths *)
val compare : t -> t -> int

(** The first symbol of the path  *)
val source : t -> Symbol.sym

(** The list of symbols in the path, in reverse order  *)
val rev_path : t -> Symbol.sym list
  
(** [mem p c] returns true when c appears in p  *)
val mem : t -> Symbol.sym -> bool

(** [singleton c] returns the path with only one symbol c  *)
val singleton : Symbol.sym -> t
  
(** adds a symbol at the end of the path  *)
val snoc : t -> Symbol.sym -> t
