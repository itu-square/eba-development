
open Batteries
open Cmdliner

let infer_file fn =
	let file = Frontc.parse fn () in
	Infer.of_file file

(* CLI *)

let log_level_of_int = function
	| x when x <= 0 -> Log.ERROR
	| 1 -> Log.WARN
	| 2 -> Log.INFO
	| x -> Log.DEBUG (* x >= 3 *)

let infer_files verbosity files =
	Log.color_on();
	Log.set_log_level (log_level_of_int verbosity);
	List.iter infer_file files

let files = Arg.(non_empty & pos_all file [] & info [] ~docv:"FILE")

(* TODO: Write a Cmdliner.converter for Log.log_level *)
let verbose =
	let doc = "Set the verbosity level." in
	Arg.(value & opt int 0 & info ["v"; "verbose"] ~docv:"LEVEL" ~doc)

let cmd =
	let doc = "Effect-based analysis of C programs" in
	let man = [ `S "DESCRIPTION"; `P "Author: Iago Abal <mail@iagoabal.eu>.";] in
	Term.(pure infer_files $ verbose $ files),
	Term.info "eba" ~version:"0.1.0" ~doc ~man

let () = match Term.eval cmd with `Error _ -> exit 1 | _ -> exit 0