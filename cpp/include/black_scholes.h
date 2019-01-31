class BlackScholesModel{
  public:
    BlackScholesModel(double spot, double strike, double time, 
                      double variance, double iRate)
                      :spot_(spot), strike_(strike), time_(time), 
                      variance_(variance), iRate_(iRate) {};
    double priceCall();
    double pricePut();
  private:
    double d1();
    double d2(double d1);

    double spot_, strike_, time_, variance_, iRate_;

};
