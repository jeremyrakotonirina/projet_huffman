
open Heap 
open Bs
  
let char_freq(channel:in_channel):int array=
  let freq = Array.make 256 0 in (*car byte maximum d'un caractère affichable est 126*)
  try 
    while true do
      let byte= input_byte channel in
      if byte >= 33 && byte <= 126 then  (* avoir que les caractères affichables et pas les sauts de ligne *)
        freq.(byte) <- freq.(byte) + 1
    done;
    freq
  with End_of_file -> freq

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
  while not (is_singleton tas) do
      let (n1, t1) = remove_min tas in
      let (n2, t2) = remove_min tas in
      add (n1 + n2, Node (t1, t2)) tas
  done;
  snd (find_min tas)

let rec codes tree=(*rend une liste de tuple des caractères et leur code compressé*)
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

  let tableau_codes= codes arbre_huffman in (*met les codes des caractères dans une liste de tuples*)

  let is = open_in fichierlire in (*ouvrir les fichiers*)
  let os = open_out fichierecrire in
  let ostream = of_out_channel os in

  ecrire_arbre arbre_huffman ostream; (*serialisation*)
  ecrire_feuilles arbre_huffman ostream;

  try
    while true do (*boucle jusqu'à ce qu'on arrive à la fin, i.e on finit de lire tous els caractères*)
      let byte = input_byte is in (* Lit un caractère, read_byte de bs.mli ne marchait pas bien*)
      if (byte >= 33 && byte <= 126) then( (*si c'est un caractère affichable, car on ne stocke que ceux là*)
        let code = List.assoc byte tableau_codes in
        String.iter (fun bit -> if bit == '0' then write_bit ostream 0 else write_bit ostream 1) 
        code (*parcourt la chaine de caractère code et écrit les bits dans le fichierecrire*)
      )
    done
  with End_of_file -> 
    finalize ostream;
    close_out os;
    close_in is

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
      let bit =
        try read_bit istream
        with End_of_stream -> raise End_of_file
      in
      if bit = 0 then lire_char  istream gauche
      else lire_char  istream droite

let decompresser fichierlire fichierecrire =
  let is = open_in fichierlire in
  let istream = of_in_channel is in 

  let struct_abr=lire_arbre istream in (*construire la structure de l'arbre du fichier compressé*)
  let arbre_huffman= lire_feuilles struct_abr istream in (*ajouter les feuilles*)

  let os = open_out fichierecrire in

  try (*boucle jusqu'à ce que on arrive à la fin du texte*)
    while true do
      let char_code = lire_char istream arbre_huffman in (*lit le caracètre d'un code*)
      output_char os (char_of_int char_code); (*écrit dans fichierecrire la conversion du code ASCII en lettre*)
    done
  with End_of_file -> (*fin de la boucle*)
    close_out os;
    close_in is

  









  
  
