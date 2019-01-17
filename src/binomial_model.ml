open Core_kernel
(* open Printf *)

(** calculate_factors
 *    Variance
 *    Delta time
 **)
let calculate_factors variance dt = 
  let u = exp (variance *. (sqrt@@dt)) in
  (u, 1./.u)

let martingdale_probability u d r dt = 
  let u_prob = ((exp@@(r*.dt)) -. d) /. (u -. d) in
  if (u_prob >= 0. && u_prob <= 1.) then
    u_prob, (1. -. u_prob)
  else
    raise (Failure "probabilities not between 1. and 0.")

type option_type =  
| Call
| Put

let option_payoff spot strike ~opt_type = 
  match opt_type with
  | Call -> 
    max 0. (spot -. strike)
  | Put ->
    max 0. (strike -. spot)

let prices_at_maturity u d ~spot ~periods = 
  let indices = Sequence.range 0 periods ~stop:`inclusive 
    |> Sequence.map ~f:(float) in
  let prices = Sequence.map indices ~f:(fun idx -> 
    (* Highest prices come first in the list *)
    spot*.(d**(idx)) *. u**((float periods) -.idx)) in
  Sequence.to_list prices
  
let binomial_expectation high low ~p_high ~p_low = 
  high *. p_high +. low *. p_low

let discount_price price rate dt = 
  (* Continuously discount a price at the risk free rate *)
  price *. (exp@@(-1. *. rate *. dt))

let staggered_zip lst = 
  let len = List.length lst in
  match lst with 
  | [] | [_] ->
      []
  | _::tl ->
      List.zip_exn (List.slice lst 0 (len - 1)) tl


let price_level future_prices ~p ~r ~dt = 
  let q = 1. -. p in
  List.map (staggered_zip future_prices) ~f:(fun pair -> 
    let a, b = pair in binomial_expectation a b ~p_high:p ~p_low:q)
  |> List.map ~f: (fun price -> discount_price price r dt)
  
let rec price_tree mature_prices ~p ~r ~dt = 
  if (List.length mature_prices) <= 1 then
    List.hd_exn mature_prices
  else 
    let level_prices = price_level mature_prices ~p ~r ~dt
    in
    price_tree level_prices ~p ~r ~dt

(** price_option -> float
 *  Spot price
 *  Strike price
 *  Resolution parameter
 *  Interest rate
 *  Time to maturity (in years)
 *  Variance of underlying asset
 **)
let price_option opt_type spot strike res rate ttm variance = 
  let dt = ttm /. (float res) in
  let u, d = calculate_factors variance dt in
  (* Return a random variable from martingdale_probability instead *)
  let p, _ = martingdale_probability u d rate dt in
  prices_at_maturity u d ~spot ~periods: res
    |> List.map ~f: (fun spot -> option_payoff spot strike ~opt_type)
    |> price_tree ~p ~r:rate ~dt
