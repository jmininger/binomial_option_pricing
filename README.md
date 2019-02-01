# Binomial Option Pricing #

This repo serves as a comparison of the Cox Russ Rubinstein binomial method and the
Black-Scholes equation for computing the price of options.

### Contents ###
- OCaml versions of the binomial model and the black-scholes model
  ..- Libraries and unit tests for both the binomial model and the black scholes
  model
  ..- Command Line App
  ..- Executable showing convergence with Black Scholes model
  ..- Executable used for benchmarking
  ..- Several executables demonstrating the mathematical relationship between
  inputs the the binomial model and to the value of the option
- C++ versions of the binomial model and the black-scholes model
  ..- Libraries and unit tests for both the binomial model and the black scholes 
  models
  ..- Executable used for benchmarking
- A writeup introducing financial option contracts and explaining the
intuition behind the no-arbitrage pricing proof for the binomial method


![Alt text](ocaml_cpp_benchmark.jpg?raw=true "OCaml C++ Benchmark Results")

![Alt text](binomial_model_lattice.jpg?raw=true "Binomial Lattice")
