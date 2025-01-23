(*let main () = Huffman.decompress "fichier"*)

open Huffman
open Heap
let example_tree =
  Node (
    Node (Leaf 97, Leaf 98), (* 'a', 'b' *)
    Node (Leaf 99, Node (Leaf 100, Leaf 101)) (* 'c', 'd', 'e' *)
  )

(* Fonction pour afficher un arbre pour la vérification *)
let rec print_tree tree =
  match tree with
  | Leaf char_code ->
      Printf.printf "Leaf: %c (%d)\n" (char_of_int char_code) char_code
  | Node (left, right) ->
      Printf.printf "Node:\n";
      print_tree left;
      print_tree right

let main()=
  let nomfichier = Sys.argv.(1) in
  try
    let cin = open_in nomfichier in
    let frequences = Huffman.char_freq cin in
    close_in cin; 
    Array.iteri (fun i freq -> (*itère sur les indices et les valeurs*)
      if freq > 0 then Printf.printf "Byte %d: %d occurrences\n" i freq
    ) frequences
  with Sys_error msg ->
    Printf.printf "Erreur"
    
    
  

let()=main()
