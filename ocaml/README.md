### Dependencies (can be installed with the opam pkg manager): ###
- dune
- core_kernel
- stdio
- str

### [Command line app](bin/cml_app.ml) ###
Prompts the user for inputs one by one and uses them to run the binomial
pricing model and print results.

**Instructions**

    cd ocaml
    dune exec ./bin/cml_app.exe

### [Convergence example](bin/converge_example.ml) ###
Demonstrates how the binomial model and black scholes model converge on the
same price as the resolution parameter for the binomial model is increased.

**Instructions**

      cd ocaml
      dune exec ./bin/converge_example.exe
 
### [Spot/Strike price example](bin/spot_strike_example.ml) ###
Demonstrates how the prices change when the option is in/at/out of the
money for both calls and puts.  

**Instructions**

      cd ocaml
      dune exec ./bin/spot_strike_example.exe

### [Variance example](bin/variance_example.ml) ###
Demonstrates how the prices change when the variance of the underlying asset
changes

**Instructions**

      cd ocaml
      dune exec ./bin/variance_example.exe



