# European Option Pricing #

This repo serves as a comparison of the Cox Russ Rubinstein binomial method and the
Black-Scholes equation for computing the price of options.

This repo contains:
- OCaml versions of the binomial model and the black-scholes model
- C++ version of the binomial model
- Simple OCaml command line app for using the binomial method
- Several executables written in OCaml demonstrating the mathematical
  relationship between elements of the binomial and BS model
- Unit tests for both the OCaml and C++ code
- A writeup introducing financial option contracts and explaining the
  intuition behind the no-arbitrage pricing proof for the binomial method

### Dependencies ### (can be installed with the opam pkg manager):
- dune
- core_kernel
- stdio
- str
- CMake (only for building the C++ unit tests)

### Command line app ###
Prompts the user for inputs one by one and uses them to run the binomial
pricing model and print results.

**Instructions**

    cd ocaml
    dune exec ./bin/cml_app.exe

### Convergence example ###
Demonstrates how the binomial model and black scholes model converge on the
same price as the resolution parameter for the binomial model is increased.

**Instructions**

      cd ocaml
      dune exec ./bin/converge_example.exe
 
### Spot/Strike price example ###
Demonstrates how the prices change when the option is in/at/out of the
money for both calls and puts.  

**Instructions**

      cd ocaml
      dune exec ./bin/spot_strike_example.exe

### Variance example ###
