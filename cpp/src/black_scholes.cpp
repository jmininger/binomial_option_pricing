#include "black_scholes.h"
#include <cmath>

double normalCDF(double value) {
     return 0.5 * std::erfc(-value * M_SQRT1_2);
}

double BlackScholesModel::priceCall() {
  const double d1Val = d1();
  const double d2Val = d2(d1Val);
  return spot_ * normalCDF(d1Val) - strike_ * 
    std::exp(-iRate_ * time_) * normalCDF(d2Val);
}
double BlackScholesModel::pricePut() {
  const double d1Val = d1();
  const double d2Val = d2(d1Val);
  return spot_ * normalCDF(-d1Val) - strike_ * 
    std::exp(-iRate_ * time_) * normalCDF(-d2Val);

}
double BlackScholesModel::d1() {
  const double t1 = std::log(spot_/strike_);
  const double t2 = (0.5 * variance_ + iRate_) * time_;
  const double t3 = std::sqrt(variance_ * time_);
  return (t1 + t2) / t3;
}
double BlackScholesModel::d2(double d1) {
  return d1 - std::sqrt(variance_ * time_);
}
