open Core_kernel

let print_float_list lst = 
  Printf.printf "%s\n" (List.to_string lst ~f:(Float.to_string))

type option_type =  
| Call
| Put

type recombinant_asset = 
  {spot_price:float; up:float; prob_up:float; down:float; prob_down:float}

let create_recombinant spot_price ~up ~prob_up = 
  if up <= 1. then
    raise (Failure "up factor can not be < 1")
  else if prob_up > 1. || prob_up < 0. then
    raise (Failure "prob_up must be a valid probability")
  else 
    { spot_price = spot_price;
      up = up; 
      prob_up = prob_up;
      down = (1. /. up); 
      prob_down = (1. -. prob_up)
    }

(** 
 * calculate_factors 
 *  - Returns the two factors by which the underlying asset is allowed to
 *  change by during a single time period, delta_t
 **)
let calculate_factors variance delta_t = 
  let u = exp (sqrt (variance *. delta_t)) in
  (u, 1./.u)


(** 
 * martingdale_probability 
 *  - Determines the probabilities (p*, q* ) that make the random variable, S
 *  (with possible states Su and Sd), a martingdale process. Raises an exn if 
 *  probabilites don't sum to 1.
 **)
let martingdale_probability rate ~up ~down ~delta_t = 
  let prob_u = (exp (rate *. delta_t) -. down) /. (up -. down) in
  if (prob_u >= 0. && prob_u <= 1.) then
    prob_u, (1. -. prob_u)
  else
    let error_str = Printf.sprintf "%f %f\n" prob_u (1. -. prob_u) in
    raise (Failure ("probabilities do not sum to 1. " ^ error_str))


(** 
 * option_payoff 
 *  - Calculates the profit of an option at maturity
 **)
let option_payoff spot strike ~opt_type = 
  match opt_type with
  | Call -> 
    max 0. (spot -. strike)
  | Put ->
    max 0. (strike -. spot)

  
(**
 * asset_states
 * - Creates a list of the possible prices of an asset after a specified
 * number of time periods (ordered low to high) 
 *)
let asset_states {spot_price; up; down; _}  ~periods = 
  let indices = Sequence.range 0 periods ~stop:`inclusive 
    |> Sequence.map ~f:(float) in
  let periods = float periods in
  let prices = Sequence.map indices ~f:(fun idx -> 
    spot_price *. up**idx *. down**(periods -.idx)) in
  Sequence.to_list prices
 

let binomial_expectation high low ~p_high ~p_low = 
  high *. p_high +. low *. p_low


(** 
 * discount_price
 *  - Continuously discount a price at the risk free rate
 **)
let discount_price price rate delta_t = 
  price *. (exp@@(-1. *. rate *. delta_t))


(** 
 * staggerd_map
 *  - Takes a list and applies a binary function to each element and the
 *  element in front of it. The length of the resulting list is always one less
 *  than the input list.
 **)
let staggered_map lst ~f = 
  let rec aux accum = function
    | [] | [_] -> List.rev accum
    | a::b::tl ->
        aux ((f a b)::accum) (b::tl)
  in
  aux [] lst


(** 
 * price_level
 *  - Prices a single level of a binomial pricing tree at time t using the
 *  values at time t+1
 **)
let price_level future_prices ~prob_up ~rate ~delta_t = 
  let prob_down = 1. -. prob_up in
  (* combine two functions so that two seperate mappings are not needed *)
  let discounted_expec low high = 
    let expect = binomial_expectation high low ~p_high:prob_up ~p_low:prob_down in
    discount_price expect rate delta_t
  in
  staggered_map future_prices ~f: discounted_expec
  
(** 
 * price_tree
 *  - Uses price_level to recursively price the entire recombinant tree
 **)
let rec price_tree maturity_values ~prob_up ~rate ~delta_t = 
  match maturity_values with 
  | [] | [_] ->
    List.hd_exn maturity_values
  | maturity_values -> 
    let level_prices = price_level maturity_values ~prob_up ~rate ~delta_t in
    price_tree level_prices ~prob_up ~rate ~delta_t


(** 
 * price_option
 *  - Uses the binomial model to price a European-style option
 * 
 * Parameters: 
 *    opt_type :opt_type
 *      - Type of option
 *    spot :float
 *      - Spot price of the option
 *    strike :float
 *      - Strike price of the option
 *    res :int
 *      - Number of time periods in the binomial model; resolution parameter
 *    rate :float
 *      - Interest rate
 *    time :float
 *      - Time to maturity. Measured in years
 *    variance :float
 *      - Variance of the underlying asset
 *
 **)
let price_option opt_type strike ~spot ~res ~rate ~time ~variance = 
  let delta_t = time /. (float res) in
  let up, down = calculate_factors variance delta_t in
  let prob_up, _ = martingdale_probability rate ~up ~down ~delta_t in
  let asset = create_recombinant spot ~up ~prob_up in
  asset_states asset ~periods:res
    |> List.map ~f: (fun spot -> option_payoff spot strike ~opt_type)
    |> price_tree ~prob_up ~rate ~delta_t

