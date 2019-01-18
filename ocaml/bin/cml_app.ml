open Pricing.Binomial_model

let() = 
  let p = price_option Call 52. 50. 10000 0.05 0.5 (0.12**2.) in
  Printf.printf "\nOptionPrice: %f\n" p
