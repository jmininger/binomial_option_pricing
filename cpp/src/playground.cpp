#include<iostream>
#include "meta_binomial_model.h"

struct Inputs {
  static constexpr double strike = 20;
  static constexpr double spot = 25;
  static const int resolution = 10;
  static constexpr double iRate = 0.05;
  static constexpr double time = 0.5;
  static constexpr double upFactor = 1.1;
  static constexpr double downFactor = 1./1.1;

};

int main()
{
  std::cout<<ValueAtMaturity<Inputs>::value<<std::endl;
}
