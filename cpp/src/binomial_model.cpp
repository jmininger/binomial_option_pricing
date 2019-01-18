#include "binomial_model.h"

#include <iostream>
#include <cmath>
#include <algorithm>
#include <stdexcept>
#include <vector>

using namespace std;
class Bernoulli {
  public:
    explicit Bernoulli(double p): p_(p), q_(1.-p) {};
    double getP() { return p_; };
    double getQ() { return q_; };
  private:
    double p_, q_;
};

class DiscreteRandomVar {
  /* Given takes any distr with an iterator. This allows it to easily calculate
   * the expectation */
};

Bernoulli martingdale(double upFactor, double downFactor, double rate) {
  auto probUp = ((1+rate)-downFactor)/(upFactor-downFactor);
  return Bernoulli(probUp);
}

double expectation(const double prob1, const double val1, const double prob2, const double val2) {
  // assert that the probabilities are equal
  return (prob1 * val1) + (prob2 * val2);
}

// turn this into constexpr
double discountedPrice(double iRate, double dt) {
  return (std::exp(-1. * iRate * dt));
}

double priceTree(const vector<double> &nextLevel, Bernoulli martingdale, double discountFactor) {
  if(nextLevel.size() <= 1) {
    //deal with size less than 1 (someone can maliciously pass it in)
    return nextLevel.front();
  }
  else {
    auto p = martingdale.getP();
    auto q = martingdale.getQ();
    //use vec.reserve instead??

    vector<double> currentLevel(nextLevel.size()-1);
    for(auto i = 0; i<currentLevel.size(); ++i) {
      double expect = expectation(p, nextLevel[i], q, nextLevel[i+1]);
      currentLevel[i] = expect * discountFactor;
    }
    return priceTree(std::move(currentLevel), martingdale, discountFactor);
  }
}

enum class OptionType { Call, Put };

std::vector<double> pricesAtMaturity(double upFactor, double downFactor, 
                                    Bernoulli martingdale, double iRate, 
                                    double spotPrice, double strikePrice, 
                                    int resolution, OptionType optType) {
  std::vector<double> optionValues(resolution);
  const int nodes = optionValues.size(); 
  for(auto i = 0; i<optionValues.size(); ++i) {
    double assetPrice = spotPrice * pow(upFactor, resolution-i) * pow(downFactor, i);
    switch(optType) {
      case OptionType::Call:
        optionValues[i] = max(assetPrice-strikePrice, 0.);
      case OptionType::Put:
        optionValues[i] = max(strikePrice-assetPrice, 0.);
      default:
        throw domain_error("Invalid optType");
    }
  }
  return optionValues;  
}

int main () {
  cout << "Assert this is double...doubles turn ints into doubles not vice versa: " << 1. * 5 << endl;
}
