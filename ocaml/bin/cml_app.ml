open Pricing.Binomial_model
open Core_kernel

type 'a command_line_arg = 
  {prompt: string; error_msg: string; conversion: (string -> 'a)}

let rec get_input {prompt; error_msg; conversion} = 
  let () = Stdio.Out_channel.output_string Stdio.stdout (prompt ^ ": ") in
  let () = Stdio.Out_channel.flush Stdio.stdout in
  match Stdio.In_channel.input_line Stdio.stdin with
  | None -> 
      raise (Failure "error with stdin")
  | Some input_str -> 
      try conversion input_str
      with Invalid_argument _ ->
        let () = Printf.printf "\n%s\n" error_msg in
        get_input {prompt; error_msg; conversion}

let get_float prompt = 
  let error_msg = "Try again" in
  let conversion = Float.of_string in
  get_input {prompt; error_msg; conversion}

let get_int prompt = 
  let error_msg = "Try again" in
  let conversion = Int.of_string in
  get_input {prompt; error_msg; conversion}

let get_opt_type prompt = 
  let error_msg = "Try again" in
  let conversion raw_in = 
    let call_regex = Str.regexp_case_fold "^c$\\|^call$" in
    let put_regex = Str.regexp_case_fold "^p$\\|^put$" in
    if (Str.string_match call_regex raw_in 0) then 
      Call
    else if (Str.string_match put_regex raw_in 0) then
      Put
    else 
      raise (Invalid_argument "")
  in
  get_input {prompt; error_msg; conversion}


let () = 
  let opt_type = get_opt_type 
    "Enter option_type ('c'|'call' or 'p'|'put')" in
  let spot = get_float "Enter the spot price (float)" in
  let strike = get_float "Enter the strike price (float)" in
  let variance = get_float "Enter the variance of the underlying (float)" in
  let rate = get_float "Enter the interest rate (float) " in
  let time = get_float "Enter time to maturity in years (float)" in
  let res = get_int "Enter the resolution parameter of the binomial
    model (int)" in 
  let price = 
    price_option opt_type strike ~spot ~res ~rate ~variance ~time in
  Printf.printf "\nCalculated option_price: %f\n" price

