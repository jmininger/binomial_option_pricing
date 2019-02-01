#include "binomial_model.h"

#include <algorithm>
#include <cmath>
#include <iostream>
#include <stdexcept>
#include <vector>

/* class Bernoulli { */
/*   public: */
/*     explicit Bernoulli(double p): p_(p), q_(1.-p) {}; */
/*     double getP() { return p_; }; */
/*     double getQ() { return q_; }; */
/*   private: */
/*     double p_, q_; */
/* }; */

double martingdale(double upFactor, double downFactor, double rate,
                   double deltaT) {
  return (std::exp(rate * deltaT) - downFactor) / (upFactor - downFactor);
}

bool isEven(int n) { return n % 2 == 0; }
bool isOdd(int n) { return n % 2 != 0; }

double expectation(double v1, double prob1, double v2, double prob2) {
  return (v1 * prob1) + (v2 * prob2);
}

std::vector<double> RecombinantAsset::statesAt(int timePeriods) {
  int numStates = timePeriods + 1;
  std::vector<double> states(numStates);
  for (auto i = 0; i < numStates; ++i) {
    states[i] = std::pow(up, i) * std::pow(down, numStates - 1 - i) * spotPrice;
  }
  return states;
}

double discountedFactor(double rate, double dt) {
  return (std::exp(-1. * rate * dt));
}

// Note: This is a dangerous function. It uses unsafe pointers to create and
// destroy memory. It provides a significant speedup, and is not recursive,
// which means it does not run out of memory like the alternative, commented 
// implementation below. 
double priceTree(const std::vector<double> &futureStates, RecombinantAsset asset,
                 double discountFactor) {
  if(futureStates.size() < 2)
    throw std::domain_error("less than 2 future states");

  auto p = asset.getP();
  auto q = asset.getQ();

  // Copy into deletable memory
  auto nextLevel = new double[futureStates.size()];
  for(auto i = 0; i < futureStates.size(); ++i)
    nextLevel[i] = futureStates[i];

  auto currentSize = futureStates.size() - 1;
  double* current;
  while(currentSize >= 1) {
    current = new double[currentSize]; 
    for (auto i = 0; i < currentSize; ++i) {
      double expect = expectation(q, nextLevel[i], p, nextLevel[i + 1]);
      current[i] = expect * discountFactor;
    }
    auto tmp = nextLevel;
    nextLevel = current;
    delete[] tmp; 
    currentSize--;
  }
  auto result = nextLevel[0];

  if(nextLevel) delete[] nextLevel;
  return result;
}

/* double priceTree(const std::vector<double> &nextLevel, RecombinantAsset asset, */
/*                  double discountFactor) { */
/*   if (nextLevel.size() <= 1) { */
/*     // deal with size less than 1 (someone can maliciously pass it in) */
/*     return nextLevel.front(); */
/*   } else { */
/*     auto p = asset.getP(); */
/*     auto q = asset.getQ(); */
/*     // use vec.reserve instead?? */
/*     std::vector<double> currentLevel(nextLevel.size() - 1); */
/*     for (auto i = 0; i < currentLevel.size(); ++i) { */
/*       double expect = expectation(q, nextLevel.at(i), p, nextLevel.at(i + 1)); */
/*       currentLevel[i] = expect * discountFactor; */
/*     } */
/*     return priceTree(std::move(currentLevel), asset, discountFactor); */
/*   } */
/* } */

std::vector<double> pricesAtMaturity(RecombinantAsset asset, double strikePrice,
                                     int resolution, OptionType optType) {
  std::vector<double> optionValues = asset.statesAt(resolution);
  for (auto &val : optionValues) {
    if (optType == OptionType::Call)
      val = std::max(val - strikePrice, 0.);
    else
      val = std::max(strikePrice - val, 0.);
  }
  return optionValues;
}

double recombinantFactor(double variance, double deltaT) {
  return std::exp(std::sqrt(variance * deltaT));
}

RecombinantAsset createAsset(double spot, double rate, double deltaT,
                             double variance, int resolution) {
  double upFactor = recombinantFactor(variance, deltaT);
  return RecombinantAsset(spot, upFactor, rate, deltaT);
}

double priceOption(OptionType optType, double strike, double spot,
                   double variance, double rate, double time, int resolution) {
  double deltaT = time / ((double)resolution);
  auto asset = createAsset(spot, rate, deltaT, variance, resolution);
  std::vector<double> finalStates =
      pricesAtMaturity(asset, strike, resolution, optType);
  return priceTree(finalStates, asset, discountedFactor(rate, deltaT));
}

void printVector(std::vector<double> v) {
  for (auto i : v)
    std::cout << i << ", ";
  std::cout << std::endl;
}
