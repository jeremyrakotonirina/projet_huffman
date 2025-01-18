
type element = int * char

type t = {
  data : element array;  (* Tableau contenant des couples (freq, char) *)
  mutable taille : int;    (* Taille actuelle du tas *)
}

let empty = {
    data = Array.make 256 (0,'\000'); (*car 256 bites et on initialise avec le caractère nul*)
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
    heap.taille <- heap.taille + 1;
    heap
    

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
        let petit = indice_petit heap i a in
        let petit = indice_petit heap petit b in
        if petit != i then begin
            echange heap.data i petit;
            descendre petit
        end
    in
    descendre 0;
    (min_elem, heap)
