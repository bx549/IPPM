$Title Maximum flow problem

set node /s,1,2,3,4,t/;
alias(node,i,j);

set edge(i,j) /s.1,s.2,1.3,1.4,2.1,2.4,3.t,4.3,4.t,t.s/;

table c(node,node) 'pipe capacity'
  s  1  2  3  4  t
s    4  6
1          6  2
2    4        4
3                6
4          1     2
t inf             ;


positive variable x(node,node);
free variable z ;

equations
 capacities(node,node) 'capacities of pipes'
 flow 'objective function'
 balances 'node s balance'
 balance1 'node 1 balance'
 balance2 'node 2 balance'
 balance3 'node 3 balance'
 balance4 'node 4 balance'
 balancet 'node t balance';

capacities(edge(i,j)).. x(edge) =l= c(edge) ;
flow.. z =e= x('t','s');
balances..x('s','1') + x('s','2') - x('t','s') =e= 0;
balance1..x('1','3') + x('1','4') - x('s','1') - x('2','1') =e= 0;
balance2..x('2','4') + x('2','1') - x('s','2') =e= 0;
balance3..x('3','t') - x('1','3') - x('4','3') =e= 0;
balance4..x('4','3') + x('4','t') - x('1','4') - x('2','4') =e= 0;
balancet..x('t','s') - x('3','t') - x('4','t') =e= 0;

model maxflow /all/;
solve maxflow using lp maximizing z;

