$Title A maxi-min problem
set i 'companies' /1,2,3,4/;
set j 'events' /A,B,C/;

Table a(i,j) 'investment returns'
  A  B  C
1 -4 6  5
2 4  -2 -11
3 -5 7  12
4 12 6  -4;

scalar b 'total of investments' /50/;

integer variable x(i) 'dollars to invest in company i';
free variable w 'minimum return among the three events';

equations
 amountinvest 'dollars to invest'
 return(j) 'return for each event';


amountinvest.. sum(i,x(i)) =e= b;
return(j).. sum(i,x(i)*a(i,j)) - b =g= w;

model investments /all/;
solve investments using MIP maximizing w;






