* the forester problem described in class
* $onEolCom

Variable
x1
x2
z;

Positive Variable x1, x2;

Equation
 obj
 budget
 acres;

obj.. z =e= 40*x1 + 70*x2;
budget.. 10*x1 + 50*x2 =l= 4000;
acres.. x1 + x2 =l= 100;

Model forester / all /;
*forester.OptFile = 1;   !! this tells GAMS to read the CPLEX options file

solve forester using LP maximizing z;

