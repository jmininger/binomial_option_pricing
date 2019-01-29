open Core_kernel

type option_type = |Call |Put

(** normal_cdf - combines multiple terms to approximate the cdf of a standard
 * normal distribution *)
let normal_cdf z =
  let t1 = -358.*.z/.23. in
  let t2 = 111.*. (Float.atan (37.*.z/.294.)) in
  let t3 = exp (t1 +. t2) in
  1./. (t3+.1.);;

let d1 spot strike rate variance time = 
  let t1 = log (spot /. strike) in 
  let t2 = (0.5 *.variance +. rate) *. time in
  let t3 = sqrt (variance *. time) in
  (t1 +. t2) /. t3

let d2 d1 variance time = 
  d1 -. (sqrt (variance *. time))

let black_scholes_call spot strike ~variance ~rate ~time = 
  let d1 = d1 spot strike rate variance time in
  let d2 = d2 d1 variance time in
  spot *. (normal_cdf d1) -. strike*. (exp (-1.*.rate*.time))
    *.(normal_cdf d2)

let black_scholes_put spot strike ~variance ~rate ~time = 
  let d1 = d1 spot strike rate variance time in
  let d2 = d2 d1 variance time in
  let t1 = strike *. (exp (-1. *. rate *. time)) *. (normal_cdf (-1. *. d2)) in
  let t2 = spot *. (normal_cdf (-1. *. d1)) in
  t1 -. t2

let black_scholes opt_type spot strike ~variance ~rate ~time = 
  match opt_type with
  | Call -> black_scholes_call spot strike ~variance ~rate ~time
  | Put -> black_scholes_put spot strike ~variance ~rate ~time
