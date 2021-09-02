(** Representation and manipulation of characters A-Z, as well as
  * functions on such characters and subsets of those characters. *)

(** Characters of A-Z. *)
type sym

(** Character A. *)
val a : sym

(** The number of characters in A-Z, that is 26. *)
val nb_syms : int

(** Conversions between [sym] and [char] and [int] respectively. *)

val of_char : char -> sym
val to_char : sym -> char

val of_int : int -> sym
val to_int : sym -> int

(** Successor of a symbol: A goes to B, B goes to C...
  * and Z goes to A. *)
val next : sym -> sym

(** Addition and subtraction of integers underlying symbols,
  * modulo [nb_syms]. For example, A+X=X for all X and
  * B+B=C. *)

val (++) : sym -> sym -> sym
val (--) : sym -> sym -> sym

(** Iteration over all symbols, in order. *)
val iter : (sym -> 'a) -> unit

(** [fold f x] computes
  * [f (f ... (f x A) ... Y) Z]. *)
val fold : ('a -> sym -> 'a) -> 'a -> 'a

(** Implementation of subsets of [sym]. *)
module Set : sig
  type t
  val empty : t
  val member : sym -> t -> bool
  val add : sym -> t -> t
  val singleton : sym -> t
end

(** Implementation of maps from [sym] to an arbitrary type. *)
module Map : sig

  type 'a t

  val get : 'a t -> sym -> 'a
  val set : 'a t -> sym -> 'a -> unit

  (** Creates a constant map. *)
  val make : 'a -> 'a t

  (** [init f] a map associating [f s] to each symbol [s]. *)
  val init : (sym -> 'a) -> 'a t

  val copy : 'a t -> 'a t

  val map : ('a -> 'b) -> 'a t -> 'b t

  (** Compute the inverse of an bijective map. *)
  val inverse : sym t -> sym t

  (** Print a symbol map by printing its 26 characters. *)
  val print_tmap : out_channel -> sym t -> unit

end
