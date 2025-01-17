
type 'a t = {
  data : 'a array;  (* Tableau  pour stocker les éléments *)
  mutable taille : int;  (* Taille actuelle du tas *)
}

let empty = {
    data = Array.make 256 0; (*car 256 bites*)
    taille = 0;
  }

let parent i = (i - 1) / 2

let enfant_gauche i = 2 * i + 1

let enfant_droite i = 2 * i + 2

(* Échanger deux éléments dans le tableau *)
let echange arr i j =
  let temp = arr.(i) in
  arr.(i) <- arr.(j);
  arr.(j) <- temp

let add heap x = (*algorithme ajout élément tas binaire*)
    heap.data.(heap.taille) <- x;
    let rec remonter i =
      if i > 0 then
        let p = parent i in
        if (heap.data.(i) < heap.data.(p)) then begin
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

let remove_min heap = (*algorithme suppression élément tas binaire*)
    if heap.taille = 0 then failwith "Le tas est vide";
    let min_elem = heap.data.(0) in
    heap.taille <- heap.taille - 1;
    heap.data.(0) <- heap.data.(heap.taille);
    let rec descendre i =
        let l = enfant_gauche i in
        let r = enfant_droite i in
        let smallest =
            if l < heap.taille && heap.data.(l) < heap.data.(i) then l else i
        in
        let smallest =
            if r < heap.taille && heap.data.(r) < heap.data.(smallest) then r else smallest
        in
        if smallest != i then begin
            echange heap.data i smallest;
            descendre smallest
        end
    in
    descendre 0;
    min_elem
