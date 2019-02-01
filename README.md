# Binomial Option Pricing #

### Contents ###
1) Binomial option model
2) OCaml implementation notes and examples
3) C++ implementation notes
4) Performance benchmark/comparison


## 1) Binomial Option Model

For an introduction to options see the attached writeup: 
[Binomial Option Pricing: A practical introduction in OCaml ](IntroToOptionPricing.pdf)

The binomial model represents the option's underlying asset as a random process with a
Bernoulli distribution--with a walk of all the states taking the shape of a
lattice-like structure: 

![Alt text](binomial_model_lattice.jpg?raw=true "Binomial Lattice")

The lattice structure allows the binomial model to calculate the price of an
option during all the discrete-time periods. This makes it more versatile than
its continuous-time analog, the black-scholes equation, which can only price an
option at a single point in time. This makes the binomial model the model of
choice for pricing American and Bermudan options. While computationally slower than the
black-scholes model, the binomial model is more accurate. This is due to the
black-scholes' reliance on the cumulative distribution function of a normal
distribution, which can only be numerically approximated. An example of this
can be seen in the [executable](ocaml/bin/convergence_example.ml) that prints a
side-by-side comparison of the black-scholes price and the binomial price as
the resolution on the binomial model is increased (the resolution represents
the number of discrete time periods). The difference between the two prices
decreases as the resolution increases, but slightly increases as the resolution
is set to 10,000. This is because of the cdf approximation used in the
black-scholes model, which is only accurate to about four decimal places. 

## 2) OCaml Implementation

The OCaml folder contains implementations of both the binomial model and the black-scholes
model. The binomial model uses linked lists to enumerate the possible states
of the underlying asset in each discrete time period. A modified mapping
function is then used to take the expectation of each adjacent state, and
then calculate the prior state from which the two current states have been
derived. 

Also included in the OCaml section is a [command line app](ocaml/bin/cml_app.ml) 
that prompts the user for each of the required details regarding the options contract. 
It then prints the price of the option to stdout

Inside ocaml/bin are a number of executables the demonstrate how the price of
an option is affected by changing the various inputs. Comments explaining the
intuition behind the relationships can be seen as comments in the code. 
See the [OCaml README](ocaml/README.md) for more details

## 3) C++ Implementation
  
Like the ocaml/ folder, cpp/ contains implementations of both the binomial
model and the black-scholes model. It also contains a playground.cpp
executable showing the convergence between the two models. 

## 4) Performance Comparison
Both the C++ and OCaml implementation of the binomial models were benchmarked
with varying resolutions (500, 1000, 5000, 7000, 10000, 15000, and 20000). Each
model was run 100 times for each resolution, and the results were averaged:

![Alt text](ocaml_cpp_benchmark.jpg?raw=true "OCaml C++ Benchmark Results")

As the resolution increased, the difference between the time that it took for
the C++ model to finish and the OCaml model to finish increased exponentially.
This was originally not the case--the C++ model had only been a small
percentage faster than the OCaml model, until a resolution of 30,000 made light
of a bug in which the C++ model's stack overflowed on large resolutions. 
This was because the C++ model was recursive and each vector representing the
future states were being passed in as an argument to the next recursive
function call. This resulted in the compiler not being able to deallocate the
memory until the recursion came back --it was not tail-recursive. The
implementation was switched to heap based memory allocation (using manual
memory management), and a speedup of about 4x was achieved. This is likely due
to the fact that the allocator did not have to work so hard to find extra
memory when more needed to be allocated. 
