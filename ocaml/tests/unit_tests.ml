open OUnit2 
open Core_kernel
open Pricing.Binomial_model

(** NOTE: The commented tests below will no longer compile, as the functions
 * that they are meant to test have been hidden by the mli interface
 *)

let round_4dec (n:float) : float = 
  Float.round_decimal ~decimal_digits: 4 n

(* let binomial_expectation_test _ = *) 
(*   let expected = (4. *. 0.75) +. (1. *. 0.25) in *)
(*   let actual = binomial_expectation (4.) (1.) ~p_high:0.75 ~p_low:0.25 *)
(*   in *)
(*   assert_equal expected actual *)

(* let martingdale_test _ = *) 
(*   let expected = 0.7564, (1. -. 0.7564) in *)
(*   let actual = martingale_probability 0.05 ~up:1.1 ~down:0.9 ~delta_t:1. in *)
(*   let ep, eq = expected in let ap, aq = actual in *)
(*   let () = assert_equal (round_4dec ep) (round_4dec ap) in *) 
(*   assert_equal (round_4dec eq) (round_4dec aq) *)

(* let recombinant_factors_test _ = *) 
(*   let expected = 1.099977, 0.909110 in *)
(*   let actual = calculate_factors 0.00908 1. in *)
(*   let e1, e2 = expected in let a1, a2 = actual in *)
(*   let () = assert_equal (round_4dec e1) (round_4dec a1) in *)
(*   assert_equal (round_4dec e2) (round_4dec a2) *)

(* let option_payoff_test _ = *) 
(*   let expected = [0.; 10.; 0.] in *)
(*   let actual = [ *)
(*     option_payoff 10. 20. ~opt_type:Call; *)
(*     option_payoff 20. 10. ~opt_type:Call; *)
(*     option_payoff 20. 10. ~opt_type:Put *)
(*   ] in *) 
(*   assert_equal expected actual *)

(*  let asset_states_test _ = *) 
(*   let asset = create_recombinant 10. ~up:2. ~prob_up:0.5 in *)
(*   let expected = [2.5; 10.; 40.] in *)
(*   let actual = asset_states asset ~periods:2 in *)
(*   assert_equal expected actual *)

(* let staggered_map_test _ = *) 
(*   let expected = [3; 5; 7; 9; 11; 13; 15; 17; 19] in *)
(*   let actual = staggered_map [1;2;3;4;5;6;7;8;9;10] ~f:(+) in *)
(*   assert_equal expected actual *)

(* let price_tree_level_test _ = *) 
(*   let expected = [0.; 15.1088] in *)
(*   let actual = price_level [0.; 0.; 21.] ~prob_up:0.7564 ~rate:0.05 ~delta_t:1. *) 
(*   in *)
(*   (1* helper function effectively rounds float to nearest .01 to compare *1) *)
(*   let float_compare n = *) 
(*     Float.to_int (n *. 100.) in *)
(*   assert_equal *) 
(*     (List.map expected ~f: float_compare) *) 
(*     (List.map actual ~f:float_compare) *)

let option_price_test _ = 
  let expected = Float.to_int 10.8703 in
  let actual = (price_option Call 100. ~spot:100. ~res:2 
    ~rate:0.05 ~time:2. ~variance:0.00908)
  in 
  assert_equal expected (Float.to_int actual)

let suite = 
  "Pricing unit tests " >:::
    [
      (* "binomial expectation simple " >:: binomial_expectation_test; *)
      (* "martingdale probability calculation" >:: martingdale_test; *)
      (* "recombinant factors calculation" >::recombinant_factors_test; *)
      (* "calculates option payoff " >:: option_payoff_test; *)
      (* "calculates prices at maturity " >:: asset_states_test; *)
      (* "staggered map test" >:: staggered_map_test; *)
      (* "prices option tree level " >:: price_tree_level_test; *)
      (* "prices options correctly " >:: option_price_test; *)
    ]

let () = run_test_tt_main suite
