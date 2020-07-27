$set partitioning problem

set i "regions" /1*6/;

alias (i,j);

table a(i,j) "internet speed in region j when served by central office in region i"
  1  2  3  4  5  6
1 45 35 30 25 10 12
2 35 45 20 20 25 18
3 30 20 45 30 15 25
4 25 20 30 45 12 27
5 10 25 15 12 45 30
6 12 18 25 27 30 45;

binary variable x(i,j)
binary variable y(i);

free variable z;

equations
 offices 'number of central offices to construct'
 assignment(j) 'Assignment of regions to a central office'
 constraint(i,j) 'logical constraint'
 speed 'objective function'
 ;

offices.. sum(i,y(i)) =e= 3;
assignment(j).. sum(i,x(i,j)) =e= 1;
constraint(i,j).. x(i,j) =l= y(i);
speed.. z =e= sum((i,j),x(i,j)*a(i,j))/6;

model internet /all/;
solve internet using mip maximizing z;
