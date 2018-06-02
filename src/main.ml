open Types
open Eval
open Js_of_ocaml

let denv = ref (initial_global_env ())
       
let e1 = List([Atom(Symbol(Named("*"))); (Atom(Number(Int(2)))); (Atom(Number(Int(2))))])
             (* let e2 = read "(+ 1 2)" *)

let test () =
  let res = eval e1 [] !denv
  in Printf.printf "Sexp = %s, result = %s\n" (Print.print_sexp e1) (Print.print_sexp res)
  (* Implement more test functions here *)

let _ = test ()

(* Export the interface to Javascript. *)
let _ =
  Js.export "repl"
            (object%js
                 
               method reset echo =
                 let ppf = js_formatter echo in
                 Format.fprintf ppf "%s -- programming languages zoo@\n@." L.name ;
                 L.initial_environment

               method toplevel echo env cmd =
                 let ppf = js_formatter echo in
                 match L.toplevel_parser with
                 | None ->
                    Format.fprintf ppf "I am sorry but this language has no interactive toplevel." ;
                    env
                 | Some p ->
                    begin try
                        let cmd = Js.to_string cmd in
                        let cmd = p (Lexing.from_string cmd) in
                        L.exec ~ppf env cmd
                      with
                      | Zoo.Error err -> Zoo.print_error ~ppf err ; env
                    end

               method usefile echo env cmds =
                 let ppf = js_formatter echo in
                 match L.file_parser with
                 | None ->
                    Format.fprintf ppf "I am sorry but this language has no non-interactive interpreter." ;
                    env
                 | Some p ->
                    begin
                      try
                        let cmds = Js.to_string cmds in
                        let cmds = p (Lexing.from_string cmds) in
                        List.fold_left (L.exec ~ppf) env cmds
                      with
                      | Zoo.Error err -> Zoo.print_error ~ppf err ; env
                    end
             end)
  
