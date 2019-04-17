exception Program_exit of string

module Path = struct let (/) = Filename.concat end
     
let main output_file input_file =
  let js = Printf.sprintf {js|os.file.writeTypedArrayToFile("%s",new Uint8Array(wasmTextToBinary(os.file.readFile("%s"))));|js} output_file input_file in
  let sm_path = match(Sys.getenv_opt "SM_PATH") with
    | Some p -> p
    | None -> Path.(".." / "spidermonkey" / "js" / "src" / "build_OPT.OBJ" / "js" / "src" / "js") in
  let _ = Unix.execv sm_path [| sm_path; "-e"; js |] in
  ()

let () =
  if (Array.length Sys.argv) < 3 then
      raise (Program_exit "In sufficient args\n")
  else
      main Sys.argv.(1) Sys.argv.(2)
