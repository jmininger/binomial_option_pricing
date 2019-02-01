# Binomial Option Pricing #

### Contents ###
1) Binomial option model
2) OCaml implementation notes and examples
3) C++ implementation notes
4) Performance benchmark and comparison


## 1) Binomial Option Model

For an introduction to options see the attached writeup: 
[Binomial Option Pricing: A practical introduction in OCaml ](IntroToOptionPricing.pdf)

The binomial model represents the option's underlying asset as a random process with a
Bernoulli distribution. A walk of all of the asset's states takes the shape of a
lattice-like structure: 

![Alt text](binomial_model_lattice.jpg?raw=true "Binomial Lattice")

The lattice structure allows the binomial model to calculate the price of an
option during any the discrete-time periods. This makes it more versatile than
its continuous-time analog, the black-scholes equation, which can only price an
option at a single point in time. The ability to determine an option's maximum
value at any future point in time makes the binomial model the model of
choice for pricing American and Bermudan options. 

While computationally slower than the black-scholes model, the binomial model 
is more accurate. This is due to the black-scholes' reliance on the cumulative distribution 
function of a normal distribution, which can only be numerically approximated. An example 
of this can be seen in [ocaml/bin/converge_example.ml](ocaml/bin/converge_example.ml). 
The latter executable prints a side-by-side comparison of the black-scholes price and 
the binomial price as the resolution on the binomial model is increased (the resolution 
represents the number of discrete time periods). As the resolution of the binomial model 
increases, the difference between the prices of the two models decreases. The latter
relationship holds until between resolutions of 1,000 and 10,000, where the difference in prices 
increases due to the cdf approximation function used in the
black-scholes model. The approximation is only accurate to about four decimal places. 

## 2) OCaml Implementation

The OCaml folder contains implementations of both the binomial model and the black-scholes
model. The binomial model uses linked lists to enumerate each of the possible states
of the underlying asset in a discrete time period. A modified mapping
function is then used to take the expectation of each adjacent state, which in
turn is then used to calculate the prior state.

Also included in the OCaml section is a [command line app](ocaml/bin/cml_app.ml) 
that prompts the user for each of the required details about the options contract. 
It then prints the price of the option to stdout

Inside ocaml/bin are a number of executables that demonstrate how the price of
an option can be affected by changing the function's various inputs. Comments explaining the
intuition behind the relationships are in their respective files.
See the [OCaml README](ocaml/README.md) for more details

## 3) C++ Implementation
  
Like the ocaml/ folder, cpp/ contains implementations of both the binomial
model and the black-scholes model. It also contains a playground.cpp
executable showing the convergence between the two models. 

## 4) Performance Comparison
Both the C++ and OCaml implementation of the binomial models were benchmarked
with varying resolutions (500, 1000, 5000, 7000, 10000, 15000, and 20000). Each
model was run 100 times per each resolution, and the results were averaged:

![Alt text](ocaml_cpp_benchmark.jpg?raw=true "OCaml C++ Benchmark Results")

As the resolution increased, the difference between the time that it took for
the C++ model to finish and the OCaml model to finish increased exponentially.
Originally, this was not the case--the C++ model had only been a small
percentage faster than the OCaml model, until a resolution of 30,000 revealed
a bug in which the C++ model's stack overflowed on large resolutions. 
The bug occurred because the C++ model was recursive and each vector representing the
future states was being passed in as an argument to the next recursive
function call. This resulted in the compiler not being able to deallocate the
memory until the recursion finished--it was not tail-recursive. The
implementation was switched to heap based memory allocation (using manual
memory management), and a speedup of about 4x was achieved. This is likely due
to the fact that the allocator did not have to work so hard to find extra
memory when more needed to be allocated. 
