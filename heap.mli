type tree =
  | Leaf of int
  | Node of tree * tree

type element = int * tree (*frequence * code de la lettre*)

type t = {  
  data : element array;  (* Tableau contenant des couples (freq, char) *)
  mutable taille : int;    (* Taille actuelle du tas, mmutable permet de le modifier *)
}


(** The type of heaps. Elements are ordered using generic comparison.
*)

val empty : t
(** [empty] is the empty heap. *)

val add : element -> t -> unit
(** [add e h] add element [e] to [h]. *)

val find_min : t -> element
(** [find_min h] returns the smallest elements of [h] w.r.t to 
    the generic comparison [<] *)

val remove_min : t -> element 
(** [remove_min h] returns the pair of the smallest elements of [h] w.r.t to 
    the generic comparison [<] and [h] where that element has been removed. *)

val is_singleton : t -> bool
(** [is_singleton h] returns [true] if [h] contains one element *)

val is_empty : t -> bool
(** [is_empty h] returns [true] if [h] contains zero element *)