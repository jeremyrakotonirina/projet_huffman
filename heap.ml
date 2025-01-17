
type 'a t = (*tas binaire minimum pour la file de priorité*)
    |Empty
    |Node of 'a * 'a t * 'a t

let empty = Empty

let rec add e tas =
    match tas with
    | Empty -> Node (e, Empty, Empty)
    | Node (y, gauche, droite) -> 
      if compare e y <= 0 then (*Si e<=y*)
        Node (e, add y gauche, droite)  
      else
        Node (y, add e gauche, droite)

let is_singleton heap =
    match heap with
    | Node (_, Empty, Empty) -> true
    | _ -> false

let is_empty heap =
    match heap with
    | Empty -> true
    | _ -> false

let find_min heap =
    match heap with
    | Empty -> failwith "Le tas est vide"
    | Node (x, _, _) -> x

let remove_min _ = failwith "todo"
