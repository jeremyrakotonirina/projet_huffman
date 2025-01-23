(*let main () = Huffman.decompress "fichier"*)

open Huffman
open Heap


(* Fonction pour afficher un arbre pour la vérification *)


let main()=
  (*
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
    *)
    let fichier_texte = "test.txt" in
    let fichier_compresse = "resultat.hf" in
    let fichier_decompresse="decompresse.txt" in
  
    compresser fichier_texte fichier_compresse;

  

  decompresser fichier_compresse fichier_decompresse
    
    
  

let()=main()
