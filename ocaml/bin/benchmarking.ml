open Pricing.Binomial_model
open Core_kernel

let strike = 50.
let spot = 52.
let rate = 0.05
let time = 0.5
let variance = 0.12**2.
let resolutions = [500; 1000; 5000; 7000; 10000; 15000; 20000]

let iterations = 100
let benchmark_with_res res = 
  let sums = ref 0. in
  for i = 0 to iterations do
    let t1 = Sys.time () in
    let _ = ignore (price_option Call strike ~spot ~res ~rate ~time ~variance) in
    let t2 = Sys.time () in
    let () = ignore i in
    sums := !sums +. (t2 -. t1)
  done; 
  !sums /. (Int.to_float iterations)

let () = 
   List.map resolutions ~f: benchmark_with_res
   |> List.zip_exn resolutions 
   |> List.iter ~f: (fun pair -> let res, time = pair in Printf.printf
   "Resolution: %d , Time: %f\n" res time)
