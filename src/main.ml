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

let js_formatter echo =
    let buffer = ref "" in
    Format.make_formatter
    (fun s p n -> buffer := !buffer ^ String.sub s p n )
    (fun () ->
      (Js.Unsafe.fun_call echo [| Js.Unsafe.inject (Js.string !buffer) |] : unit) ;
      buffer := "")

(* Export the interface to Javascript. *)
let _ =
  Js.export "repl"
            (object%js
                 
               method reset echo =
                 let ppf = js_formatter echo in
                 Format.fprintf ppf "%s - echo" echo;

                 (*
               method toplevel echo env cmd =   
                 begin try     
                     let cmd = Js.to_string cmd in
                     let cmd = p (Lexing.from_string cmd) in
                     L.exec ~ppf env cmd
                   with
                   | Zoo.Error err -> Zoo.print_error ~ppf err ; env
                 end *)
                 
               method usefile echo env cmds =
                 let ppf = js_formatter echo in
                 let cmds = Js.to_string cmds in
                 Format.fprintf ppf "received from editor %s @." cmds;
                 env

               method compile echo env cmds =
                 let ppf = js_formatter echo in
                 let cmds = Js.to_string cmds in
                 Format.fprintf ppf "compile received: %s @." cmds;
                 env

               method interpret echo env cmds =
                 let ppf = js_formatter echo in
                 let cmds = Js.to_string cmds in
                 Format.fprintf ppf "toplevel received: %s @." cmds;
                 env
             end)
  
  
