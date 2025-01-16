(*let decompress _ = failwith "todo" *)
(*let compress _ = failwith "todo"*)

let char_freq(channel:in_channel):int array=
  let freq = Array.make 256 0 in
  try 
    while true do
      let byte= input_byte channel in
      freq.(byte) <- freq.(byte) + 1
    done;
    freq
  with End_of_file -> freq
