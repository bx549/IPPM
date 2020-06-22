positive variables
x1 'earplugs'
x2 'other PPE';

free variable
value;

equations budget, earplugs, other, objective;
budget.. x1 + x2 =l= 100;
earplugs.. x1 =l= 70;
other.. x2 =l= 50;
objective.. value =e= 1.2*x1 + x2;

model equipment /all/;
solve equipment using lp maximizing value;
