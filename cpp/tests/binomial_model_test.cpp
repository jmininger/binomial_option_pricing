#include "gtest/gtest.h"
#include "binomial_model.h"
#include <vector>
#include <cmath>

int roundToNear(double n, int decimals) {
  return int (n * std::pow(10, decimals));
} 

TEST(Martingdale, computes_correct_probability) { 
  auto p = martingdale(1.100, 0.900, 0.05, 1.);
  EXPECT_DOUBLE_EQ(p, 0.75635548188012025);
}

TEST(Expectation, is_computed_properly) {
  double expect = expectation(4., .75, 1., .25);
  EXPECT_DOUBLE_EQ(expect, 3.25);
}

TEST(AssetStatesAtFunc, odd_number_of_states) {
  auto asset = RecombinantAsset(100.00, 1.100, 0.05, 1.);
  auto actual = asset.statesAt(2);
  auto expected = std::vector<double>{82.644, 100., 121.};
  ASSERT_EQ(actual.size(), expected.size());
  for(auto i = 0; i<actual.size(); ++i)
    EXPECT_DOUBLE_EQ(std::round(100.*expected[i]), std::round(100.*actual[i]));
}

TEST(DiscountedFactor, calculates_discount) {
  auto actual = discountedFactor(0.05, 1.); 
  auto expected = 0.9512;
  EXPECT_EQ(roundToNear(actual, 4), (roundToNear(expected, 4)));
}

TEST(Price_tree, properly_prices_a_recombinant_tree) {
  auto asset = RecombinantAsset(100.00, 1.1, 0.05, 1.);
  auto actual = priceTree({0., 0., 21.}, asset, 0.9512);
  auto expected = 10.538;
  EXPECT_EQ(roundToNear(expected, 3), roundToNear(actual, 3));
}

TEST(MaturePricing, properly_calcs_prices_at_maturity) {
  auto asset = RecombinantAsset(100.00, 1.1, 0.05, 1.);
  auto actual = pricesAtMaturity(asset, 100., 2, OptionType::Call);
  auto expected = std::vector<double>{0., 0., 21.};
  for(auto i = 0; i<actual.size(); ++i)
    EXPECT_EQ(roundToNear(expected[i], 2), roundToNear(actual[i], 2));
}

TEST(PriceOption, works) {
  auto expected = 3.80805;
  auto actual = priceOption(OptionType::Call, 50., 52.,
                            std::pow(0.12, 2), 0.05, 0.5, 10);
  EXPECT_EQ(roundToNear(expected, 4), roundToNear(actual, 4));
}
