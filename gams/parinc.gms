* Par, Inc problem from Anderson Ch 2
$OnEolCom

Positive Variables s,  !! number of standard bags
                   d;  !! number of deluxe bags
Variables z;           !! objective function value

Equations obj, cutting, sewing, finishing, inspection;
obj .. z =e= 10*s + 9*d;
cutting ..  7/10*s + d =l= 630;
sewing ..  1/2*s + 5/6*d =l= 600;
finishing .. s + 2/3*d =l= 708;
inspection .. 1/10*s + 1/4*d =l= 135;

Model parinc / all /;
parinc.OptFile = 1;

solve parinc using LP maximizing z;

