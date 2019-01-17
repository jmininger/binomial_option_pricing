open OUnit2
(* open Pricing *)

let test1 _ = 
	assert_equal 1 1

let suite =
  "Options pricing" >:::
   [ 
     "Simple call option" >:: test1;
   ]
(* Price 100, K = 100, u = 1.1, d = .9, r = .05, two periods (T=2, t = 0),
 * answer = 10.87 *)


let () = run_test_tt_main suite
