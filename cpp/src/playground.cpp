#include<iostream>
#include "black_scholes.h"
#include "binomial_model.h"

int main()
{
  BlackScholesModel bsm {25., 20., 0.5, 0.05, 0.05};
  std::cout<< bsm.priceCall() <<std::endl;

  std::cout << 
    priceOption(OptionType::Call, 20., 25., 0.05, 0.05, 0.5, 10000)
    << std::endl;
  
}
