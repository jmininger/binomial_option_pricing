
let d1 spot strike rate variance time = 
 ((log (spot /. strike)) +. (rate +. (variance *. 0.5) *. time)) /. ((sqrt
   variance) *. (sqrt time)) 

let d2 spot strike rate variance time = 
  ((log (spot /. strike)) +. (rate -. (variance *. 0.5) *. time)) /. ((sqrt
   variance) *. (sqrt time)) 

let standard_normal_cdf z integral t =
  integral (1. /. (sqrt (2.*.Float.pi)) *. (exp (-0.5 *.(t**2.))))


let black_scholes spot strike rate time cdf d1 d2= 
  spot *. (cdf d1) -. strike*. (exp (-1.*.rate*.(float time))) *.(cdf d2)
