sets
i 'ingredients' /1,2,3,4/;
parameters
a(i)'cost of ingredient i'
/ 1 3
  2 0.75
  3 1.8
  4 0.6/
b(i) 'protein content of ingredient i'
/ 1 125
  2 12
  3 14
  4 32/
c(i) 'fat content of ingredient i'
/ 1 60
  2 4
  3 1.5
  4 8/
d(i) 'fiber content of ingredient i'
/ 1 0
  2 9
  3 12
  4 17/;

variables
x(i) 'fraction of mixture of ingredient i'
z    'cost per pound of dog food'
positive variables x;

equations
fat 'upper bound on total fat content',
protein 'lower bound on total protein content',
fiberlow 'lower bound on total fiber content',
fiberup 'upper bound on total fiber content',
minimum(i) 'minimum fraction of each ingredient i',
total 'sum of fractions must equal 1',
chickveg 'lower bound on fraction of chicken and vegetables',
cost 'objective function';

fat.. sum(i,x(i)*c(i)) =l= 40;
protein.. sum(i,x(i)*b(i)) =g= 80;
fiberlow.. sum(i,x(i)*d(i)) =g= 4;
fiberup.. sum(i,x(i)*d(i)) =l= 10;
minimum(i).. x(i) =g= .1;
total..sum(i,x(i)) =e= 1;
chickveg.. x('1') + x('3') =g= .8;
cost.. z =e= sum(i,x(i)*a(i));

model mixture /all/;
solve mixture using lp minimizing z;
