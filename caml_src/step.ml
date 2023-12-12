(* Copyright (C) 2017 Sio Kreuzer. All Rights Reserved.
   Copyright (C) 2023 James DuPont. All Rights Reserved.
   *)

open CErrors
open Constr
open Context
open EConstr
open Environ
open Evarutil
open Evd
open Genarg
open Gramlib
open Logic
open Ltac_plugin
open Nameops
open Names
open Pp
open Pretype_errors
open Vernac_classifier
open Vernacexpr
open Vernacextend
open Vernacinterp
open Vernacprop
open Vernacstate
open WorkerPool
open Pvernac
open Range
open Reductionops
open Sertop.Sertop_init
open Tacred
open Tactypes
open Termops
open Tok
open Pcoq
open Unification
open Util
open Vars
open! Sexplib.Conv
module Loc = Serlib.Ser_loc
module Names = Serlib.Ser_names
module Evar = Serlib.Ser_evar
module Parsable = Pcoq.Parsable
module Evar_kinds = Serlib.Ser_evar_kinds


let get_default_proof_mode()=
  match Pvernac.lookup_proof_mode "Noedit" with
    Some x -> x;;

let step (s:string ) =
  coq_init
    {
      fb_handler = (fun _ _ -> ())  (* XXXX *);
      plugin_load=None;
      debug = true;
      set_impredicative_set=true;
      allow_sprop=true;
      indices_matter=true;
      ml_path=["/mnt/data1/2023/12/11/alec-is-not-coq-lsp/_build/install/default/lib/ml"];
      vo_path=[];
    } Format.std_formatter;
  Printf.printf "Hello Ocaml from LLama\n";
  let p1 = (Vernacstate.Parser.init()) in
  let s1 = (Stream.of_string s) in
  let pa = Pcoq.Parsable.make s1 in
  try
    Vernacstate.Parser.parse p1 (Pvernac.main_entry (Some (get_default_proof_mode ()))) pa;
    s ^ "Hello Ocaml1\n";
  with Gramlib.Grammar.Error x->
    Printf.printf "error1: '%s'" x;
 
    Printf.printf "test: '%s'" s;
  flush stdout;
  s ^ "Hello Ocaml\n";;
let init () =
    Printf.printf "Initializing Game module...\n";
    flush stdout;;

let shutdown () =
    Printf.printf "Shutting down Game module...\n";
    flush stdout;;


(* main/init *)
let () =
    Callback.register "init_fn" init;
    Callback.register "shutdown_fn" shutdown;
    Callback.register "step_fn" step;;
