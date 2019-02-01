#include <iostream>
#include <cmath>
#include <ctime>
#include "binomial_model.h"

constexpr int iterations = 100;
const double variance = std::pow(0.12, 2);

double benchmarkWithRes(double res) {
  double total = 0.;
  for(auto i = 0; i < iterations; ++i) {
    std::clock_t c_start = std::clock();
    priceOption(OptionType::Call, 50., 52., variance, 0.05, 0.5, res);
    std::clock_t c_end = std::clock();
    total += ((c_end - c_start) / (double)CLOCKS_PER_SEC);
  }
  return total / (double)iterations;
}

int main() {
  std::vector<int> resolutions = {500, 1000, 5000, 7000, 10000, 15000, 20000};
  std::vector<double> times;
  for(auto res : resolutions) {
    times.push_back(benchmarkWithRes(res));
  }
  for(auto i = 0; i < times.size(); ++i)
    std::cout << "Resolution: " << resolutions[i] << " , Time: " << times[i] << std::endl;

}
