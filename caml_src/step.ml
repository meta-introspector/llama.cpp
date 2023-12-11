(* Copyright (C) 2017 Sio Kreuzer. All Rights Reserved.
   Copyright (C) 2023 James DuPont. All Rights Reserved.
   *)

open Sertop.Sertop_init

(*
let init2 () =
  let stm_options = process_stm_flags stm_flags in
  let stm_options =
    { stm_options with
      async_proofs_tac_error_resilience = `None;
      async_proofs_cmd_error_resilience = false
    } in
  let stm_options =
    if quick
    then { stm_options with async_proofs_mode = APonLazy }
    else stm_options
  in
  let injections = [Stm.RequireInjection ("Coq.Init.Prelude", None, Some false)] in
  let ndoc = { Stm.doc_type = Stm.VoDoc in_file
             ; injections
             ; ml_load_path
             ; vo_load_path
             ; stm_options
             } in
  if quick || stm_flags.enable_async <> None
  then Safe_typing.allow_delayed_constants := true;
  let coq_lp_conv ~implicit (unix_path,lp) = Loadpath.{
      coq_path  = Libnames.dirpath_of_string lp	;
      unix_path			   ;
      has_ml = true		   ;
      recursive = true		   ;
      implicit
    };
    ;;
*)
       
let init () =
    Printf.printf "Initializing Game module...\n";
    flush stdout;;

let shutdown () =
    Printf.printf "Shutting down Game module...\n";
    flush stdout;;

let load_path : Loadpath.vo_path list = []

let step (s:string) : string =

  coq_init
    {
      fb_handler = (fun _ _ -> ())  (* XXXX *);
      plugin_load=None;
      debug = true;
      set_impredicative_set=true;
      allow_sprop=true;
      indices_matter=true;
      ml_path=["/mnt/data1/2023/12/11/alec-is-not-coq-lsp/_build/install/default/lib/ml"];
      vo_path=load_path;
    } Format.std_formatter;
  Printf.printf "Hello Ocaml from LLama\n";
  flush stdout;
        s ^ "Hello Ocaml\n";;


(* main/init *)
let () =
    Callback.register "init_fn" init;
    Callback.register "shutdown_fn" shutdown;
    Callback.register "step_fn" step;;
