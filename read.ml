type char_type =
  | INVALID
  | S_ESCAPE
  | M_ESCAPE
  | WHITESPACE
  | CONSTITUENT

type case = UPPER | LOWER

type char_info = {
  ml_char : char;
  id : string;
  description : string;
  syntax_type : char_type
}
		      
type readtable =
    {
      info : (char, char_info) Hashtbl.t;
      case : case
      (* Macro characters here? *)
    }

let null_table () =
  {
    info = Hashtbl.create 255;
    case = UPPER;
  }
      
let make_char_info rt ctype ~desc ~id c =
  let ci = { id = id; ml_char = c; description = desc; syntax_type = ctype }
  in Hashtbl.add rt.info c ci

let setup_default_chars rt =
  for i = 0 to 26 do
    let cu = (Char.chr (65+i))
    and cl = (Char.chr (97+i))
    in 
    make_char_info rt CONSTITUENT cu ~desc:"capital %c" ~id:(Printf.sprintf "L%c02" cu);
    make_char_info rt CONSTITUENT cl ~desc:"small %c" ~id:(Printf.sprintf "L%c01" cl);
  done;
  make_char_info rt CONSTITUENT '0' ~desc:"digit 0" ~id:"ND00";
  for i = 1 to 9 do
    make_char_info rt CONSTITUENT (Char.chr (48+i))
		   ~desc:"digit %c" ~id:(Printf.sprintf "ND%u" i);
  done
    
let default_ascii =
  let n = null_table ()
  in setup_default_chars n;
     n

exception ReaderError of int
exception EndOfFile

let next_char stream = ' '

type read_flags = PREV_ESCAPE 
			 
let read ?(table=default_ascii) stream output_tokeniser =
  let read_pos = ref 0
  in
  let bump_pos () = (read_pos := !read_pos + 1)
  and emit t = (output_tokeniser t)
  in 
  let rec _read flag tok =
    try
      bump_pos ();
      let c = next_char stream
      in match (Hashtbl.find table.info c).syntax_type with
	 | INVALID -> raise (ReaderError !read_pos)
	 | WHITESPACE ->
	    begin
	      begin
		if List.length tok > 0 then emit tok
		else ()
	      end;
	      _read None []
	    end
	 | S_ESCAPE -> _read (Some PREV_ESCAPE) []
	 | M_ESCAPE -> _read None (c::tok)
	 | CONSTITUENT -> _read None (c::tok)
    with Not_found -> _read flag tok
  in _read None []
