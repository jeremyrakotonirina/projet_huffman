let main () = Huffman.decompress "fichier"


let () = main ()

let nomfichier = Sys.argv.(1) in
try
  let cin = open_in nomfichier in
  let frequences = Huffman.char_freq cin in
  close_in cin; 
  Array.iteri (fun i count ->
    if count > 0 then Printf.printf "Byte %d: %d occurrences\n" i count
  ) frequences
with Sys_error msg ->
  -1