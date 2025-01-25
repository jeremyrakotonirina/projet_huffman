
open Huffman
open Heap

let verifier_existence fichier =
  if not (Sys.file_exists fichier) then (
    Printf.printf "Erreur : le fichier %s n'existe pas.\n" fichier;
    exit 3
  )

let taille_fichier fichier = (*renvoie la taille d'un fichier*)
  let is = open_in fichier in
  let taille = in_channel_length is in
  close_in is;
  taille

let stats fichier= (*compresse le fichier et renvoie des statistiques sur la compression  *)
  verifier_existence fichier;
  let fichier_compresse = fichier ^ ".hf" in
  compresser fichier fichier_compresse;
  
  let taille_originale = taille_fichier fichier in (*trouve la taille en octets*)
  let taille_compressee = taille_fichier fichier_compresse in
  let taux_compression = 100.0 *. (1.0 -. (float_of_int taille_compressee /. float_of_int taille_originale)) in

  Printf.printf "Statistiques de compression :\n";
  Printf.printf "Taille originale : %d octets\n" taille_originale;
  Printf.printf "Taille compressée : %d octets\n" taille_compressee;
  Printf.printf "Taux de compression : %.2f%%\n" taux_compression;
  exit 0


let main()=
  (*code d'erreur: 1 si option non renconnue;
                   2 si erreur au niveau de nombre d'argument;
                   3 si fichier inexistant*)

  match Array.length Sys.argv with
  | 1 -> (* Aucun argument fourni *)
      Printf.printf "Erreur : aucun argument .\n";
      exit 2

  | 2 -> (*1 argument*)
    let arg = Sys.argv.(1) in
    if arg = "--help" then  (*on affiche l'aide*)
      begin
      Printf.printf "Options :\n";
      Printf.printf "  --help            Affiche ce message d'aide\n";
      Printf.printf "  fichier           Compresse le fichier donné en argument pour produire fichier.hf\n";
      Printf.printf "  fichier.hf        Décompresse le fichier donné en argument pour produire fichier\n";
      Printf.printf "  --stats fichier   Compresse le fichier mais affiche des statistiques sur ce dernier\n";
      exit 0
      end
    else if Filename.check_suffix arg ".hf" then ( (*si l'extension est .hf on décompresse*)
      verifier_existence arg;
      let fichierecrire="2" ^ Filename.chop_suffix arg ".hf" in (*enlève l'extension .hf du fichier et rajoute un 2 au début pour le distinguer du fichier d'origine*)
      Printf.printf "Décompression du fichier %s dans %s\n" arg fichierecrire;
      decompresser arg fichierecrire;
      exit 0
    ) else ( (*sinon on compresse*)
      verifier_existence arg;
      let fichiercompresse = arg ^ ".hf" in (*on rajoute le .hf car on va compresser*)
      Printf.printf "Compression du fichier %s dans %s \n" arg fichiercompresse;
      compresser arg fichiercompresse;
      exit 0
    )

  | 3 ->
    let option = Sys.argv.(1) in
    let fichier = Sys.argv.(2) in
    if option = "--stats" then (
      stats fichier
    ) else (
      Printf.printf "Erreur : option non reconnue \n";
      exit 1
    )
  | _ -> (* Trop d'arguments *)
    Printf.printf "Erreur : trop d'arguments.\n";
    exit 2

    
  

let()=main()
