set I "all locations" /1,2,3,4,5/;
alias(I,J);
set K(I) "factory 1" /1/;
set L(I) "factory 2" /2/;
set M(I) "distribution center" /3/;
set N(I) "warehouse 1" /4/;
set O(I) "warehouse 2" /5/;
set P(I) "factories" /1,2/;  
set Q(I) "warehouses" /4,5/;
set R(I) "dc and warehouse 1" /3,4/;
set S(I) "dc and warehouse 2" /3,5/;
set T(I) "factory 1 and dc" /1,3/;
set U(I) "factory 2 and dc" /2,3/;

table a(I,J) "shipping cost from i to j"
  1  2  3  4  5
1       3  7
2       4     9
3          2  4
4
5              ;

parameter b(K) "factory 1 supply" /1=80/;
parameter c(L) "factory 2 suuply" /2=70/;
parameter d(N) "warehouse 1 demand" /4=60/;
parameter e(O) "warehouse 2 demand" /5=90/;
scalar f "shipping capacity" /50/;

positive variable x(I,J) "number of products shipped from i to j";
free variable z;

equations factory1(K), factory2(L), warehouse1(N), warehouse2(O), capacity1(P,M), capacity2(M,S), balance, cost;
factory1(K).. sum(R,x(K,R)) =e= b(K);
factory2(L).. sum(S,x(L,S)) =e= c(L);
warehouse1(N)..sum(T,x(T,N)) =e= d(N);
warehouse2(O)..sum(U,x(U,O)) =e= e(O);
capacity1(P,M)..x(P,M) =l= f;
capacity2(M,S)..x(M,S) =l= f;
balance.. sum((P,M),x(P,M)) - sum((M,Q),x(M,Q)) =e= 0;
cost.. z =e= sum((I,J),a(I,J)*x(I,J));

model supplychain /all/;
solve supplychain using lp minimizing z;