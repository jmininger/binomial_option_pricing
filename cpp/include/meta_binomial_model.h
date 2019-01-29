
// An attempt to use template metaprogramming to run the entire calculation at
// compile time


constexpr double max(double v1, double v2) { return v1 > v2 ? v1:v2;}

template <typename inputs>
struct ValueAtMaturity {
  static constexpr double value = max(inputs::spot-inputs::strike, 0.);
};

// PricesAtMaturity<Resolution, inputs>
// specialization for when res is 1 -> begin returning 
