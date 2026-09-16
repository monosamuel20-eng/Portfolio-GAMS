set TimeIndex /t_1 * t_30/;

alias (TimeIndex, t);

Sets
   tfirst(t) 
   tlast(t)
   tnolast(t);
   
tfirst(t)$(ord(t) =1) =yes;
tlast(t)$(ord(t) =card(t)) =yes;
tnolast(t) = not tlast(t);

Scalars
   rho "discount factor" /0.05/
   g "Growth rate" /0.03/
   delta "capital depreciation" /0.02/;
  
scalars
   K0 "initial capital" /3.0/
   C0 "initial consumption" /0.95/
   L0 "initial labour" /1.0/
   I0 "initial invesrment" /0.05/
   alpha "cobb douglas" /0.25/
   A;

Parameter
   L(t)
   beta(t);
   
L(t) = L0 * power((1+g), ord(t) -1);
A= (C0+I0) / (K0**alpha * L0**(1-alpha));
beta (tnolast(t)) =power (1+rho, -(ord(t)-1) );
beta (tlast(t)) =(1.0/rho)* power(1.0+rho, 1- (ord(t)-1));

Display A, L, tfirst, tlast, tnolast, beta;

Variables
   C(t)
   Y(t)
   K(T)
   I(t)
   W;
   
Equations
   ProductionEq(t)
   Allocattioneq(t)
   AccocumaltionEq(t)
   Welfare
   Final(t);
   
ProductionEq(t).. Y(t)=E=A*K(t)**alpha* L(t)**(1-alpha);
Allocattioneq(t).. C(t)+ I(t) =E= Y(t);
AccocumaltionEq(tnolast(t)).. K(t+1)=E= (1-delta)* K(t)+I(t);
Welfare.. W =E= sum(t, beta(t)*log(C(t)));
Final(tlast).. I(tlast) =G= (g+delta) * K(tlast);

model Ramsey /all/;

K.LO(t) =0.01;
C.LO(t) =0.01;

K.fx(tfirst) = K0;
C.fx(tfirst) = C0;
I.fx(tfirst) = I0;

Solve Ramsey Maximising W using NLP;
Display C.L,K.L,I.L,W.L;


