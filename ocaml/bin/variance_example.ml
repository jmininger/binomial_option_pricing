open Pricing.Binomial_model
open Core_kernel

(*** 
 * This example shows the relationship between the price of an option and the
 * variance of a stock. As the variance increases, the price of an option also
 * increases. While the variance (the square root of the volatility) affects
 * both the up and down factors equally, the value of an option has a lower
 * bound of $0 because the right to buy/sell at maturity can always be waived.
 * There is however no upper bound on the price of the option, which means that
 * as the variance increases, the potential for higher profits increases, which
 * increases the option price
 *)
 
let () = 
  let variances = [0.0001; 0.0005; 0.001; 0.005; 0.01; 0.05] in
  let spot = 80. in
  let strike = 83. in
  let time = 0.5 in
  let rate = 0.05 in
  let res = 1000 in
  let prices = List.map variances ~f: (fun variance -> 
    price_option Call strike ~spot ~res ~rate ~time ~variance) in
  List.iter prices ~f: (fun price -> Printf.printf "Price: %f\n" price)
