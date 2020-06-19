sets
i 'vegetable' / lettuce, broccoli, carrots /;

parameters
a(i) 'space required by vegetable in sq. ft.'
/ lettuce 0.5
  broccoli 1.2
  carrots 0.25 /
c(i) 'profit of each vegetable in dollars'
/ lettuce 9.5
  broccoli 12.8
  carrots 8.25 /
  d(i) 'demand for each vegetable'
/ lettuce 350
  broccoli 350
  carrots 250 /;

variables
x(i) 'number of plants of type i'
z    'total profit of garden';
positive variables x;

equations
profit 'objective function',
space  'limit on available garden space',
demand ' limit on demand for vegetables';

profit.. z =e= sum(i, c(i)*x(i));
space.. sum(i, a(i)*x(i)) =l= 400;
demand(i).. x(i) =l= d(i);

model garden /all/;
solve garden using lp maximizing z;
