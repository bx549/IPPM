$Title Supply chain problem

set node / fac1, fac2, dc, wh1, wh2 /;

alias (node,i,j);

set edge(i,j)
  / fac1.dc, fac1.wh1,
    fac2.dc, fac2.wh2,
    dc.wh1, dc.wh2 /;

set capedge(node,node) 'capacitated edge'
  / fac1.dc, fac2.dc, dc.wh1, dc.wh2 /;

table c(node,node) 'cost to ship one unit'
     dc wh1 wh2
fac1  3   7
fac2  4       9
dc        2   4
;

sets
  factory(node) / fac1, fac2 /
  warehouse(node) / wh1, wh2 /
  distr(node) / dc /;
    
parameter a(factory) 'supply at factory'
  / fac1 = 80
    fac2 = 70 /;
parameter b(warehouse) 'demand at warehouse'
  / wh1 = 60
    wh2 = 90 /;
scalar u "shipping capacity" / 50 /;
                     
positive variable x(node,node);
free variable z;

equations
  cost       'objective function'
  supply(factory)     'cannot exceed supply at factory'
  demand(warehouse)   'must meet demand at factory'
  transhipment(distr) 'flow balance at dc'
  capacity(node,node) 'capacity on edges to/from dc'
  ;
  
cost.. z =e= sum(edge, c(edge)*x(edge));

supply(factory).. sum(node $ edge(factory,node), x(factory,node)) =l= a(factory);
demand(warehouse).. sum(node $ edge(node,warehouse), x(node,warehouse)) =g= b(warehouse);
transhipment(distr).. sum(j $ edge(distr,j), x(distr,j)) - sum(i $ edge(i,distr), x(i,distr)) =e= 0;
capacity(capedge(i,j)).. x(capedge) =l= 50;

model supplychain / all /;

solve supplychain using lp minimizing z;
