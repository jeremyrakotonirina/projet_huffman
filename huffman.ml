(*let decompress _ = failwith "todo" *)
(*let compress _ = failwith "todo"*)
open Heap 
  
let char_freq(channel:in_channel):int array=
  let freq = Array.make 256 0 in
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




  
  
