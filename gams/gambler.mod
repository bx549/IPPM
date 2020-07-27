# a gambler divides her money ($500) among four options.
# there are three possible outcomes. the outcome is determined
# by a random event A, B, C. the gambler's strategy is to
# maximize the minimum return.

var x1 >=0;   # amount to invest in option 1
var x2 >=0;
var x3 >=0;
var x4 >=0;
var w;        # represents the minimum among the three outcomes

maximize minreturn: w;

s.t. amountbet: x1+x2+x3+x4=500;
s.t. outcomeA: -3*x1 + 4*x2 - 7*x3 + 15*x4 - 500 >= w;
s.t. outcomeB: 5*x1 - 3*x2 + 9*x3 + 4*x4 - 500 >= w;
s.t. outcomeC: 3*x1 - 9*x2 + 10*x3 - 8*x4 - 500 >= w;
