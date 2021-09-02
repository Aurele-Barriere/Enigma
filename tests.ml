(** Tests *)
(* Uncomment as you implement features *)

open Symbol
(* open Graph *)
(* open Cycles *)
(* open Path *)
(* open Board *)
   
let () =
  if Filename.basename Sys.argv.(0) = "tests" then begin
      Printf.printf "Testing Symbol Module:\t";
      assert (to_char (of_char 'A') = 'A');
      assert (to_char (of_char 'B') = 'B');
      assert (to_char (of_char 'Y') = 'Y');
      assert (to_char (of_char 'Z') = 'Z');
      assert (to_char a = 'A' && of_char 'A' = a);
      assert (to_int (of_int 17) = 17);
      assert (of_int (to_int a) = a);
      assert ((of_char 'A') ++ (of_char 'X') = of_char 'X');
      assert ((of_char 'B') ++ (of_char 'B') = of_char 'C');
      assert ((of_char 'C') ++ (of_char 'Y') = of_char 'A');
      assert ((of_char 'K') -- (of_char 'A') = of_char 'K');
      assert ((of_char 'D') -- (of_char 'L') = of_char 'S');
      assert (fold (fun _ c -> c) a = of_char 'Z');
      assert (fold (fun n _ -> n+1) 0 = nb_syms);
      
      let s = Symbol.Set.add (of_char 'B') (Symbol.Set.singleton (of_char 'E')) in
      assert (Symbol.Set.member (of_char 'E') s);
      assert (Symbol.Set.member (of_char 'B') s);
      assert (Symbol.Set.member (of_char 'F') s = false);
      
      let sa = Symbol.Set.add (of_char 'A')
                (Symbol.Set.add (of_char 'A') Symbol.Set.empty) in
      assert (Symbol.Set.member (of_char 'A') sa);
      
      let sfull = fold (fun s c -> Symbol.Set.add c s) Symbol.Set.empty in
      iter (fun c -> assert (Symbol.Set.member c sfull));
      
      let mfull = Symbol.Map.make sfull in
      assert (Symbol.Set.member a (Symbol.Map.get mfull (of_char 'K')));

      let mplusone = Symbol.Map.init (fun c -> c ++ (of_char 'B')) in
      assert (Symbol.Map.get mplusone (of_char 'Z') = a);
      
      let mint = Symbol.Map.init (fun c -> to_int c) in
      let mcopy = Symbol.Map.copy mint in
      Symbol.Map.set mcopy (of_char 'L') 0;
      assert (Symbol.Map.get mint (of_char 'L') = 11);
      assert (Symbol.Map.get mcopy (of_char 'L') = 0);

      let mmap = Symbol.Map.map (fun i -> of_int i) mint in
      assert (Symbol.Map.get mmap (of_char 'L') = of_char 'L');
      assert (Symbol.Map.get mmap (of_char 'T') = of_char 'T');

      let mminusone = Symbol.Map.inverse mplusone in
      assert (Symbol.Map.get mminusone (of_char 'W') = of_char 'V');
      assert (Symbol.Map.get mminusone (of_char 'A') = of_char 'Z');
      
      Printf.printf "OK\n";
    end

(*
let () =
  if Filename.basename Sys.argv.(0) = "tests" then begin
      Printf.printf "Testing Graph Module:\t";
      let g = Graph.create() in
      add_edge g a (of_char 'B') 1;
      add_edge g a (of_char 'C') 2;
      add_edge g (of_char 'B') a 3;
      
      assert (get_edge g (of_char 'B') (of_char 'C') = Positions.empty);
      assert (Positions.mem 3 (get_edge g a (of_char 'B')));
      assert (Positions.mem 1 (get_edge g a (of_char 'B')));
      assert (Positions.mem 3 (get_edge g (of_char 'B') a));
      assert (Positions.mem 1 (get_edge g (of_char 'B') a));
      assert (Positions.mem 2 (get_edge g (of_char 'B') a) = false);

      assert (fold_over_connected g (fun c s -> c ++ s) a a = (of_char 'D'));
      assert (fold_over_connected g (fun i _ -> i+1) 0 a = 2);
      add_edge g a (of_char 'Z') 4;
      assert (fold_over_connected g (fun i _ -> i+1) 0 a = 3);
                      
      Printf.printf "OK\n";
    end
 *)

(*
let () =
    if Filename.basename Sys.argv.(0) = "tests" then begin
      Printf.printf "Graph Generation:\t";
      let g = graph_of_known_cipher "ABCDBAA" "ZZHKYYY" in
      assert (Positions.mem 0 (get_edge g a (of_char 'Z')));
      assert (Positions.mem 0 (get_edge g (of_char 'Z') a));
      assert (Positions.mem 1 (get_edge g (of_char 'Z') (of_char 'B')));
      assert (Positions.mem 2 (get_edge g (of_char 'H') (of_char 'C')));
      assert (Positions.mem 3 (get_edge g (of_char 'D') (of_char 'K')));
      assert (Positions.mem 4 (get_edge g (of_char 'Y') (of_char 'B')));
      assert (Positions.mem 5 (get_edge g (of_char 'A') (of_char 'Y')));
      assert (Positions.mem 6 (get_edge g (of_char 'A') (of_char 'Y')));
      assert (Positions.mem 1 (get_edge g (of_char 'Z') a) = false);
      assert (get_edge g (of_char 'Z') (of_char 'Y') = Positions.empty);
      Printf.printf "OK\n";
    end
 *)

(*
let () =
  if Filename.basename Sys.argv.(0) = "tests" then begin
      Printf.printf "Testing Path Module:\t";
      let p = snoc (singleton a) (of_char 'J') in
      assert (source p = a);
      let p' = snoc (snoc p a) (of_char 'X') in
      assert (rev_path p' = [of_char 'X'; a; of_char 'J'; a]);

      assert (mem p' a);
      assert (mem p' (of_char 'E') = false);
      assert (mem (singleton a) (of_char 'X') = false);

      assert (Path.compare p p = 0);
      assert (Path.compare p' p > 0);
              
      Printf.printf "OK\n";
    end
 *)

(*  
let () =
  if Filename.basename Sys.argv.(0) = "tests" then begin
      Printf.printf "Testing Cycles Module:\t";

      (* TODO: as the return type of Cycles.cycles is free,
       * you have to write your own tests about this function
       * In the previous example, for messages "ABCDBAA" and "ZZHKYYY",
       * you should find 7 useful cycles in the multi-graph,
       * which correspond to 11 cycles in the original graph
       * 
       * The unexpanded cycles are the following ones: *)
      
      (* - A(5,6)Y(5,6)A
       * - A(5,6)Y(4)B(1)Z(0)A
       * - A(0)Z(0)A
       * - B(4)Y(4)B
       * - B(1)Z(1)B
       * - C(2)H(2)C
       * - D(3)K(3)D *)

      (* Write some tests for your functions to see if you get 
       * the same numbers of cycles *)

      Printf.printf "TODO\n";
    end
 *)

(*  
let () =
  if Filename.basename Sys.argv.(0) = "tests" then begin
      Printf.printf "Board (1st version):\t";
      let b = top () in
      assert (possible b a a);
      assert (possible b (of_char 'Z') (of_char 'J'));
      
      remove_assoc b a a;
      assert (possible b a a = false);
      assert (possible b (of_char 'Z') (of_char 'J'));

      remove_assoc b a (of_char 'B');
      assert (possible b a (of_char 'B') = false);
      assert (possible b (of_char 'B') a = false);
      assert (possible b (of_char 'Z') (of_char 'J'));

      (* removing all possible associations for a letter
         leads to an impossible board *)
      assert (
          try (Symbol.iter (fun c -> remove_assoc b a c); false) with
          | Impossible -> true);

      let b' = top () in
      (* removing all associations for A except Q *)
      Symbol.iter (fun c ->
          match (c = (of_char 'Q')) with
          | false -> remove_assoc b' a c
          | true -> ());

      assert (possible b' a (of_char 'Q'));
      assert (possible b' (of_char 'Q') a);
      assert (possible b' (of_char 'Q') (of_char 'T') = false);
      assert (possible b' a (of_char 'R') = false);

      Printf.printf "OK\n";
    end
 *)

(*  
let () =
  if Filename.basename Sys.argv.(0) = "tests" then begin
      Printf.printf "Board (semipersistent):\t";
      let b = top () in
      assert (possible b a a);
      
      remove_assoc b a (of_char 'X');
      assert (possible b a (of_char 'X') = false);

      let s = save b in
      remove_assoc b a (of_char 'V');
      assert (possible b a (of_char 'V') = false);

      let s' = save b in
      remove_assoc b a (of_char 'B');
      assert (possible b a (of_char 'B') = false);

      restore s';
      assert (possible b a (of_char 'X') = false);
      assert (possible b (of_char 'X') a = false);
      assert (possible b a (of_char 'V') = false);
      assert (possible b (of_char 'V') a = false);
      assert (possible b a (of_char 'B'));
      assert (possible b (of_char 'B') a);

      restore s;
      assert (possible b a (of_char 'X') = false);
      assert (possible b (of_char 'X') a = false);
      assert (possible b a (of_char 'V'));
      assert (possible b (of_char 'V') a);
      assert (possible b a (of_char 'B'));
      assert (possible b (of_char 'B') a);      

      Printf.printf "OK\n";
    end
 *)
