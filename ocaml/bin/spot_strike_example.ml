open Pricing.Binomial_model
open Core_kernel

(***
 * This example shows the relationship between the option price and the
 * difference of the spot and the strike prices. 
 * When a call option is out-of-the-money (meaning the strike price is greater
 * than the spot price) and the difference between the two is inreased (given a
 * constant variance) the price eventually hits 0 and stays at this number
 * In general, an increased spot price increases the price of the call option,
 * while an increased strike price decreases the price of a call option. 
 * The opposite is true for put options. 
 *)

(* Model constants *)
let strike = 80. 
let time = 3.
let rate = 0.05 
let variance = 0.005 
let res = 1000 

let print_option msg difference_list opt_type = 
  Stdio.print_endline "";
  List.iter difference_list ~f:(fun diff ->
    Printf.printf "%s. spot-strike diff: %d, option_price: %f \n"
    msg (Int.of_float diff) 
    (price_option opt_type strike ~spot:(strike+.diff) ~res ~rate 
      ~time ~variance))

let () = 
  let at_money = [0.] in
  let in_diffs = [5.; 10.; 20.; 40.; 80.] in
  let out_diffs = [-5.; -10.; -20.; -40.; -80.] in
  print_option "Out of the money call option" out_diffs Call;
  print_option "In the money call option" in_diffs Call;
  print_option "At the money call option" at_money Call;
  print_option "Out of the money put option" out_diffs Put;
  print_option "In the money put option" in_diffs Put;
  print_option "At the money put option" at_money Put;
