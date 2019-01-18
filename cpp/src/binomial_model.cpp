#include <iostream>
#include <string>
#include <vector>

using namespace std;
class Bernoulli {
  public:
    explicit Bernoulli(float p): p(p), q(1.-p) {};
  private:
    float p, q;
};

class DiscreteRandomVar {
  /* Given takes any distr with an iterator. This allows it to easily calculate
   * the expectation */
};

Bernoulli martingdale(float up, float down, float rate) {
  auto probUp = ((1+r)-d)/(u-d);
  return Bernoulli(probUp);
}


int main () {

}
