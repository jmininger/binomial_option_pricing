type option_type =  
| Call
| Put

(** 
 * price_option
 *  - Uses the binomial model to price a European-style option
 * 
 * Parameters: 
 *    opt_type :opt_type
 *      - Type of option
 *    strike :float
 *      - Strike price of the option
 *    spot :float
 *      - Spot price of the option
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
val price_option: option_type -> float -> spot:float -> res:int ->
  rate:float -> time:float -> variance:float -> float
