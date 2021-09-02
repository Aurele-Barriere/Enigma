(** Implementation of non-oriented graphs with symbols as vertices
  * and integer-labelled multi-edges. *)

(** The submodule [Positions] provides an implementation of sets of integers. *)
module Positions : Set.S with type elt = int

(** The type of non-oriented graphs whose vertices are symbols of [Symbol.sym]
  * and edges are labelled by integer sets. All edges are labelled, and the
  * empty set is used when there is no edge between two vertices. *)
type t

(** Create an empty graph. *)
val create : unit -> t

(** [add_edge g a b i] adds the integer [i] to the set that labels
  * the (non-oriented) edge between [a] and [b]. *)
val add_edge : t -> Symbol.sym -> Symbol.sym -> int -> unit

(** [get_edge g a b] returns the label of the edge between [a] and [b] in [g].
  * As a particular case, the empty set is returned when there is no edge
  * between the two vertices. *)
val get_edge : t -> Symbol.sym -> Symbol.sym -> Positions.t

(** [fold_over_connected g f x s] computes [f (f ... (f x t_1) ... t_n-1) t_n]
  * where [t_1, ..., t_n] is an enumeration (in an unspecified order)
  * of the symbols that are connected to [s] in [g] with a non-empty
  * labelled edge. *)
val fold_over_connected : t -> ('a -> Symbol.sym -> 'a) -> 'a -> Symbol.sym -> 'a

(** Given a list of vertices, print the path between them, showing the
  * sets labelling the edges on that path. *)
val print_path : t -> Pervasives.out_channel -> Symbol.sym list -> unit
