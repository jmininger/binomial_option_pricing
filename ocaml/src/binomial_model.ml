open Core_kernel


type option_type =  
| Call
| Put

(** 
 * calculate_factors 
 *  - Returns the two factors by which the underlying asset is allowed to
 *  change by during a single time period
 * 
 * Parameters: 
 *    variance :float
 *      - The variance of the underlying asset
 *    dt :float
 *      - delta time. The length of a single period in the model. Measured in
 *      years
 **)
let calculate_factors variance dt = 
  let u = exp (sqrt (variance *. dt)) in
  (u, 1./.u)


(** 
 * martingdale_probability 
 *  - Determines the probabilities (p*, q* ) that make the random variable, S,
 *  a martingdale process
 * 
 * Parameters: 
 *    u :float
 *      - The up factor
 *    d :float
 *      - The down factor
 *    r :float
 *      - The continuous interest rate
 *    dt :float
 *      - delta time. The length of a single period in the model. Measured in
 *      years
 **)
let martingdale_probability u d r dt = 
  let u_prob = ((exp (r*.dt)) -. d) /. (u -. d) in
  if (u_prob >= 0. && u_prob <= 1.) then
    u_prob, (1. -. u_prob)
  else
    let () = Printf.printf "%f %f\n" u_prob (1. -. u_prob) in
    raise (Failure "probabilities do not sum to 1. ")



(** 
 * option_payoff 
 *  - Calculates the profit of an option at maturity
 * 
 * Parameters: 
 *    spot :float
 *      - The spot price of the underlying asset at maturity, S(T)
 *    strike :float
 *      - The strike price of the option
 *    opt_type :opt_type
 *      - The type of option (call or put)
 **)
let option_payoff spot strike ~opt_type = 
  match opt_type with
  | Call -> 
    max 0. (spot -. strike)
  | Put ->
    max 0. (strike -. spot)


(** 
 * prices_at_maturity 
 *  - The range of final values of the underlying asset after a specified
 *  number of time periods
 * 
 * Parameters: 
 *    u :float
 *      - The up factor
 *    d :float
 *      - The down factor
 *    spot :float
 *      - The spot price of the underlying asset at maturity, S(T)
 *    periods: int
 *      - The number of time periods in the model. AKA the resolution parameter
 **)
let prices_at_maturity u d ~spot ~periods = 
  let indices = Sequence.range 0 periods ~stop:`inclusive 
    |> Sequence.map ~f:(float) in
  let prices = Sequence.map indices ~f:(fun idx -> 
    (* Highest prices come first in the list *)
    spot*.(d**(idx)) *. u**((float periods) -.idx)) in
  Sequence.to_list prices
  
(** 
 * binomial_expectation
 *  - The expectation of a random variable with a Bernoulli distribution
 * 
 * Parameters: 
 *    high :float
 *      - The up factor
 *    low :float
 *      - The down factor
 *    p_high :float
 *      - The probability, p*, of the asset increasing by the "up" factor
 *    p_low: float
 *      - The probability, q*, of the asset decreasing by the "down" factor
 **)
let binomial_expectation high low ~p_high ~p_low = 
  high *. p_high +. low *. p_low

(** 
 * discount_price
 *  - Discounts an price by the risk free rate
 * 
 * Parameters: 
 *    price :float
 *      - Asset price
 *    rate :float
 *      - Interest rate
 *    dt: float
 *      - Length of a time period; measured in years
 **)
let discount_price price rate dt = 
  (* Continuously discount a price at the risk free rate *)
  price *. (exp@@(-1. *. rate *. dt))


(** 
 * staggerd_zip
 *  - Zips a list with another that would be identical if not for the fact that
 *  it is shifted by an index. The resulting list has a length of n-1
 *  Ex: staggered_zip [1; 2; ... 9; 10] -> [(1, 2); (2, 3); ...(8, 9); (9, 10)]
 * 
 * Parameters: 
 *    lst :'a list
 *      - A list
 **)
let staggered_zip lst = 
  let len = List.length lst in
  match lst with 
  | [] | [_] ->
      []
  | _::tl ->
      List.zip_exn (List.slice lst 0 (len - 1)) tl



(** 
 * price_level
 *  - Prices a single level of a binomial pricing tree
 * 
 * Parameters: 
 *    future_prices :float list
 *      - A list of the options prices at time: t+1
 *    p :float
 *      - Martingdale probability, p*
 *    r :float
 *      - Interest rate
 *    dt :float
 *      - delta time
 **)
let price_level future_prices ~p ~r ~dt = 
  let q = 1. -. p in
  List.map (staggered_zip future_prices) ~f:(fun pair -> 
    let a, b = pair in binomial_expectation a b ~p_high:p ~p_low:q)
  |> List.map ~f: (fun price -> discount_price price r dt)
  
(** 
 * price_tree
 *  - Uses price_level to recursively price the entire tree
 * 
 * Parameters: 
 *    mature_prices :float list
 *      - A list of the options profits at time maturity
 *    p :float
 *      - Martingdale probability, p*
 *    r :float
 *      - Interest rate
 *    dt :float
 *      - delta time
 **)
let rec price_tree mature_prices ~p ~r ~dt = 
  if (List.length mature_prices) <= 1 then
    List.hd_exn mature_prices
  else 
    let level_prices = price_level mature_prices ~p ~r ~dt
    in
    price_tree level_prices ~p ~r ~dt


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
  let dt = time /. (float res) in
  let u, d = calculate_factors variance dt in
  (* Return a random variable from martingdale_probability instead *)
  let p, _ = martingdale_probability u d rate dt in
  prices_at_maturity u d ~spot ~periods: res
    |> List.map ~f: (fun spot -> option_payoff spot strike ~opt_type)
    |> price_tree ~p ~r:rate ~dt

