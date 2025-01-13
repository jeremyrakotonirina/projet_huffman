let decompress _ = failwith "todo"
let compress _ = failwith "todo"

let char_freq(in_channel):int array=
  let freq = Array.make 256 0 in
  try 
    while true do 
      let byte= input_byte in_channel in
      freq.(byte) <- freq.(byte) + 1
  with End_of_file -> freq