sets
i "golfer" / amy, brian /
j "bidder" / emma, dan, sam /;

parameters
a(i) "available hours"
/ amy 10
  brian 10 /;
  
table bid(i,j) "dollars per hour bid"
       emma dan sam
amy      28  26  30
brian    30  28  32;

scalar maxhours "max hours won per bidder" / 8 /;

variables
x(i,j) "hours bidder j spends with instructor i"
z      "total revenue";
positive variables x;

equations
revenue "objective function"
hours   "available hours"
limit   "8 hours per bidder max";

revenue.. z =e= sum((i,j), bid(i,j)*x(i,j));
hours(i).. sum(j, x(i,j)) =e= a(i);
limit(j).. sum(i, x(i,j)) =l= maxhours;

model auction /all/;
solve auction using lp maximizing z;

$ontext
file results /results.dat/;
put results;
loop(i, put i.tl, @12, x.l(i) /);
put "profit", @12, z.l /;
$offtext