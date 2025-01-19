(*let decompress _ = failwith "todo" *)
(*let compress _ = failwith "todo"*)
open Heap 
open Bs
  
let char_freq(channel:in_channel):int array=
  let freq = Array.make 256 0 in (*car byte maximum d'un caractère affichable est 126*)
  try 
    while true do
      let byte= input_byte channel in
      if byte >= 32 && byte <= 126 then  (* avoir que les caractères affichables et pas les sauts de ligne *)
        freq.(byte) <- freq.(byte) + 1
    done;
    freq
  with End_of_file -> freq

let compression tabfreq=
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

let rec codes tree prefix acc =
  match tree with
  | Leaf char_code ->
    (char_code, prefix) :: acc
  | Node (gauche, droite) ->
    codes gauche (prefix ^ "0") (codes droite (prefix ^ "1") acc) (*on accumule les deux appels récursifs vers la gauche et la droite*)

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

let serialise tree nomfichier= 
  let fichier=open_out nomfichier in
  let ostream = of_out_channel fichier in (*crée un ostream*)
  ecrire_arbre tree ostream;       
  ecrire_feuilles tree ostream; 
  finalize ostream;              
  close_out fichier


let rec lire_arbre istream =
  let bit = read_bit istream in
  match bit with
  | 0 -> Leaf (-1) 
  | 1 ->
      let gauche = lire_arbre istream in
      let droite = lire_arbre istream in
      Node (gauche, droite)
  | _ -> raise Invalid_stream 

let rec lire_feuilles tree istream =
  match tree with
  | Leaf _ ->
      let char_code = read_byte istream in (*lit 8 bytes ie 1 octet*)
      Leaf char_code
  | Node (left, right) ->
      Node (lire_feuilles left istream, lire_feuilles right istream)

let deserialise filename =
  let fichier=open_in filename in
  let istream = of_in_channel fichier in (*crée un isteam*)
  let tree = lire_arbre istream in
  let tree_with_values = lire_feuilles tree istream in
  close_in fichier;
  tree_with_values
  









  
  
