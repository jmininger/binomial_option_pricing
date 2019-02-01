#include <vector>

enum class OptionType { Call, Put };

double martingdale(double upFactor, double downFactor, double rate,
                   double deltaT);

double expectation(double v1, double prob1, double v2, double prob2);

class RecombinantAsset {
public:
  RecombinantAsset(double spotPrice, double up, double rate, double deltaT)
      : spotPrice(spotPrice), up(up), down(1. / up) {
    probUp = martingdale(up, down, rate, deltaT);
    probDown = 1. - probUp;
  };

  std::vector<double> statesAt(int timePeriods);
  double getP() { return probUp; }
  double getQ() { return probDown; }

private:
  double spotPrice;
  double up, down;
  double probUp, probDown;
};

double discountedFactor(double rate, double dt);

double priceTree(const std::vector<double> &futureStates, RecombinantAsset asset,
                 double discountFactor);

std::vector<double> pricesAtMaturity(RecombinantAsset asset, double strikePrice,
                                     int resolution, OptionType optType);

double recombinantFactor(double variance, double deltaT);

RecombinantAsset createAsset(double spot, double rate, double deltaT,
                             double variance, int resolution);

double priceOption(OptionType optType, double strike, double spot,
                   double variance, double rate, double time, int resolution);
