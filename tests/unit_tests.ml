open OUnit2 
open Core_kernel
open Pricing.Binomial_model

(* Create a random variable with an expectation op instead *)
let binomial_expectation_test _ = 
  let expected = (4. *. 0.75) +. (1. *. 0.25) in
  let actual = binomial_expectation (4.) (1.) ~p_high:0.75 ~p_low:0.25
  in
  assert_equal expected actual

let maturity_pricing_test _ = 
  let expected = [ 40.; 10.; 2.5] in
  let actual = prices_at_maturity 2. 0.5 ~spot:10. ~periods:2 in
  assert_equal expected actual

let option_payoff_test _ = 
  let expected = [0.; 10.; 0.] in
  let actual = [
    option_payoff 10. 20. ~opt_type:Call;
    option_payoff 20. 10. ~opt_type:Call;
    option_payoff 20. 10. ~opt_type:Put
  ] in 
  assert_equal expected actual
    
let price_tree_level_test _ = 
  let expected = [15.1088; 0.] in
  let actual = price_level [21.; 0.; 0.] ~p:0.7564 ~r:0.05 ~dt:1. in
  (* helper function effectively rounds float to nearest .01 to compare *)
  let float_compare n = 
    Float.to_int (n *. 100.) in
  assert_equal 
    (List.map expected ~f: float_compare) 
    (List.map actual ~f:float_compare)
  (* assert_equal expected actual *)

let option_price_test _ = 
  let expected = Float.to_int 10.8703 in
  let actual = (price_option Call 100. 100. 2 0.05 2. 0.0953)
  in 
  assert_equal expected (Float.to_int actual)

let suite = 
  "Pricing unit tests " >:::
    [
      "binomial expectation simple " >:: binomial_expectation_test;
      "calculates prices at maturity " >:: maturity_pricing_test;
      "calculates option payoff " >:: option_payoff_test;
      "prices option tree level " >:: price_tree_level_test;
      "prices options correctly " >:: option_price_test;
    ]

let () = run_test_tt_main suite
