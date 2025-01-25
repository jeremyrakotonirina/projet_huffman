
open Heap 
open Bs

let input_code cin = (*une fonction auxiliaire qui gère directement l’exception  et rendre la récursivité terminale dans char_freq*)
   try
    input_byte cin
   with End_of_file -> -1
  
let char_freq(channel:in_channel):int array=
  let freq = Array.make 256 0 in (*car 256 bytes*)
  let rec loop () =
      let byte = input_code channel in (*utilise la fonction auxiliaire ci-dessus*)
      if byte<0 then freq
      else begin
        freq.(byte) <- freq.(byte) + 1;
        loop ()
      end
  in
  loop ()

let rec affiche_arbre tree = (*affiche l'arbre (pour les tests)*)
  match tree with
  | Leaf char_code ->
      Printf.printf "Leaf: (%d)\n"  char_code
  | Node (gauche, droite) ->
      Printf.printf "Node:\n";
      affiche_arbre gauche;
      affiche_arbre droite

let arbrehuffman tabfreq= (*renvoie un arbre de huffman en suivant l'algorithme en fonction du tableau d'occurence des caractère*)
  let tas=empty in
  Array.iteri (fun lettre occ ->
      if occ > 0 then add (occ, Leaf lettre) tas 
    ) tabfreq;
  let rec loop () =
    if is_singleton tas then snd (find_min tas) (*renvoie quand il n'y a plus qu'un seul élément*)
    else
      let (n1, t1) = remove_min tas in
      let (n2, t2) = remove_min tas in
      add (n1 + n2, Node (t1, t2)) tas; (*combine les deux noeuds avec le moins de fréquences*)
      loop ()
  in
  loop ()

let rec codes tree=(*rend une liste de 2-tuple des caractères et leur code compressé*)
  let rec codes2 tree prefix acc=
    match tree with
    | Leaf char_code ->
      (char_code, prefix) :: acc
    | Node (gauche, droite) ->
      codes2 gauche (prefix ^ "0") (codes2 droite (prefix ^ "1") acc) (*on accumule les deux appels récursifs vers la gauche et la droite*)
  in
  codes2 tree "" []

let rec ecrire_arbre tree ostream = (*écrire structure de l'arbre*)
  match tree with
  | Leaf _ ->
      write_bit ostream 0 (* Écrit 0 pour une feuille *)
  | Node (gauche, droite) ->
      write_bit ostream 1; (* Écrit 1 pour un noeud interne *)
      ecrire_arbre gauche ostream; 
      ecrire_arbre droite ostream 

let rec ecrire_feuilles tree ostream = (* écrire code des feuilles *)
  match tree with
  | Leaf char_code ->
      write_byte ostream char_code 
  | Node (gauche, droite) ->
      ecrire_feuilles gauche ostream;
      ecrire_feuilles droite ostream

let compresser fichierlire fichierecrire=
  let is = open_in fichierlire in
  let tabfreq = char_freq is in (*tableau de fréquences du fichier*)
  close_in is; (*on le ferme pour pouvoir recommencer du début à la ligne 82*)

  let arbre_huffman=arbrehuffman tabfreq in (*crée l'arbre de huffman*)
  (*affiche_arbre arbre_huffman; *) 

  let tableau_codes= codes arbre_huffman in (*met les codes des caractères dans une liste de 2-tuples*)

  let is = open_in fichierlire in (*ouvrir les fichiers*)
  let os = open_out fichierecrire in
  let ostream = of_out_channel os in

  ecrire_arbre arbre_huffman ostream; (*serialisation*)
  ecrire_feuilles arbre_huffman ostream;

  let rec loop () = (*boucle jusqu'à ce qu'on arrive à la fin, i.e on finit de lire tous els caractères*)
    let byte=input_code is in (* Lit un caractère*)
    if (byte < 0) then begin (*c'est à -1 si l'excpetion End_of_file est levée*)
        finalize ostream;
        close_out os;
        close_in is
    end
    else(
        let code = List.assoc byte tableau_codes in (*trouve le code compressé de byte*)
        String.iter (fun bit ->  (*parcourt la chaine de caractère code et écrit les bits dans le fichierecrire*)
          if bit = '0' then write_bit ostream 0 else write_bit ostream 1
        ) code;
        loop ())
  in
  loop ()

let rec lire_arbre istream =(*lit chaque bit du fichier et construit la constructure et initialise les feuilles à -1*)
  let bit = read_bit istream in
  match bit with
  | 0 -> Leaf (-1) 
  | 1 ->
      let gauche = lire_arbre istream in
      let droite = lire_arbre istream in
      Node (gauche, droite)
  | _ -> raise Invalid_stream 

let rec lire_feuilles tree istream = (*lit les bits du fichier qui correspondent aux feuilles et renvoie l'arbre avec les bonnes feuilles*)
  match tree with
  | Leaf _ ->
      let char_code = read_byte istream in (*lit 8 bytes ie 1 octet*)
      Leaf char_code
  | Node (left, right) ->
      let gauche=lire_feuilles left istream in
      let droite=lire_feuilles right istream in
      Node (gauche, droite)


let rec lire_char istream arbre_huffman = (*retourne un caractère du istream*)
  match arbre_huffman with
  | Leaf char_code -> 
      (* Si une feuille est atteinte, retourner le caractère*)
      char_code
  | Node (gauche, droite) ->
      (* Lire le prochain bit pour décider de la direction *)
      let bit = read_bit istream in (*lève l'exception End_of_stream quand on arrive à la fin*)
      if bit = 0 then lire_char  istream gauche
      else lire_char  istream droite

let lire_code istream arbre_huffman= (*fonction auxiliaire pour gérer l'exception et rendre la récursivité terminale dans decompresser*)
  try 
    lire_char istream arbre_huffman
  with End_of_stream -> -1


let decompresser fichierlire fichierecrire =
  let is = open_in fichierlire in
  let istream = of_in_channel is in 

  let struct_abr=lire_arbre istream in (*construire la structure de l'arbre du fichier compressé*)
  let arbre_huffman= lire_feuilles struct_abr istream in (*ajouter les feuilles*)

  let os = open_out fichierecrire in

  let rec loop () = (*boucle jusqu'à ce que on arrive à la fin du texte*)
      let char_code = lire_code istream arbre_huffman in (*lit le caracètre d'un code avec la fonction auxiliaire*)
      if (char_code < 0) then begin (*c'est à -1 si on atteint la fin du fichier*)
        close_out os;
        close_in is
      end
      else(
      output_char os (char_of_int char_code); (*écrit dans fichierecrire la conversion du code ASCII en lettre*)
      loop ())
  in
  loop ()

  









  
  
