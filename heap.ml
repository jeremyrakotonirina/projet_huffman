type tree =
  | Leaf of int
  | Node of tree * tree

type element = int * tree (*frequence * code de la lettre*)

type t = {  
  data : element array;  (* Tableau contenant des couples (freq, char) *)
  mutable taille : int;    (* Taille actuelle du tas, mmutable permet de le modifier *)
}

let empty = {
    data = Array.make 256 (0,Leaf 0) ; (*car 256 bites et on initialise avec des feuilles à 0 *)
    taille = 0;
    }

let parent i = (i - 1) / 2

let enfant_gauche i = 2 * i + 1

let enfant_droite i = 2 * i + 2

(* Échanger deux éléments dans le tableau *)
let echange heap i j =
  let temp = heap.(i) in
  heap.(i) <- heap.(j);
  heap.(j) <- temp

let add elt heap  = (*algorithme ajout élément tas binaire*)
    heap.data.(heap.taille) <- elt;
    let rec remonter i =
      if i > 0 then
        let p = parent i in
        if (fst heap.data.(i) < fst heap.data.(p)) then begin
          echange heap.data i p;
          remonter p
        end
    in
    remonter heap.taille;
    heap.taille <- heap.taille + 1

let is_singleton heap =
    heap.taille==1

let is_empty heap =
    heap.taille==0

let find_min heap =
    if heap.taille = 0 then failwith "Le tas est vide";
    heap.data.(0)

let indice_petit heap i j=
    if j < heap.taille && fst heap.data.(j) < fst heap.data.(i) then j else i

let remove_min heap = (*algorithme suppression élément tas binaire*)
    if heap.taille = 0 then failwith "Le tas est vide";
    let min_elem = heap.data.(0) in
    heap.taille <- heap.taille - 1;
    heap.data.(0) <- heap.data.(heap.taille); (*car dernier élément du tablea à taille-1*)
    let rec descendre i =
        let a = enfant_gauche i in
        let b = enfant_droite i in
        let petit = (*cherche le minimum entre le parent et ses 2 enfants*)
            match (a < heap.taille, b < heap.taille) with (*vérifie que les enfants sont bien dans la file*)
            | (true, true) ->
                if fst heap.data.(a) < fst heap.data.(b) then
                    if fst heap.data.(a) < fst heap.data.(i) then a else i
                else
                    if fst heap.data.(b) < fst heap.data.(i) then b else i
            | (true, false) ->
                if fst heap.data.(a) < fst heap.data.(i) then a else i
            | (false, true) ->
                if fst heap.data.(b) < fst heap.data.(i) then b else i
            | (false, false) -> i
      in
        if petit != i then begin
            echange heap.data i petit;
            descendre petit
        end
    in
    descendre 0;
    min_elem







      

    