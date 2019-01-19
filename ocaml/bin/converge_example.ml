open Pricing
open Core_kernel

(* A 6-month call option with an exercise price of $50 on a stock that is 
 * trading at $52 has a continuously compounding risk-free rate of 5% and the
 * annual standard deviation of the stock returns is 12%. *)


(* This example shows how the binomial model converges to the black-scholes
 * model as the resolution increases. The program iterates through 5 different
 * resolutions, each increasing in magnitude, and compares the price of the
 * binomial model with the price of the closed black-scholes model. It also
 * shows the absolute difference between the two *)
(* Note: At the largest resolution, 10,000, the difference in the price between
 * the two models slightly increases instead of decreasing like one might
 * expect. This is likely due to the fact that the code for the black-scholes
 * model relies on an approximation of the cdf of the standard normal 
 * distribution *)


(* Model constants *)
let strike = 50.
let spot = 52.
let rate = 0.05
let time = 0.5
let variance = 0.12**2.

let () = 
  let bsm_price = 
    Black_scholes_model.black_scholes spot strike ~rate ~time ~variance
  in
  let resolutions = [1; 10; 100; 1000; 10000] in
  List.iter resolutions
    ~f: (fun res -> 
      let bin_price = Binomial_model.price_option
        Binomial_model.Call strike ~spot ~res ~rate ~time ~variance
      in 
      Printf.printf 
        "\nResolution: %d \nBSM Price: %f\nBinPrice: %f\nDifference: %f\n"
        res bsm_price bin_price (Float.abs (bsm_price -. bin_price))
    )
