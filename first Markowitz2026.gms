* Input data Function
Set Stocks(*);
Parameters mu(*);
Parameters sigma(*,*);
Parameters beta(*);

$GDXIN "D:\Economics and Finance\Mathematics for Econmics and Finance\GAMS\DJ (2).gdx"
$load Stocks=i mu=ExpectedReturns
$load sigma=varCov
$load beta
$GDXIN

Alias (Stocks,i,j);

Scalar muP /0.01/;

* Varibale section
positive Variables
short (i); 
Variables
   x(i);
variables
   sigmaSqrP;
   
*Equation section
Equation
    portafolioVariance "Equation defining the variance"
    BudgetCon "Sum of X_i =1"
    TargetreturnCon "Sum_i X_i mu_i=muP"
    shortBalance
    BetaCon
    shortCon(i);
    
BetaCon.. sum(i, X(i)* beta(i)) =E= 1.0;
    
BudgetCon.. Sum(i, X(i))=E=1;


TargetreturnCon.. sum(i, X(i)* mu(i)) =E= muP;

portafolioVariance.. sigmaSqrP =E= sum((i,j),
                                  X(i)* X(j) *sigma(i,j));
   

shortCon(i)..short(i)=G=-X(i);

shortBalance.. sum(i, short(i)) =E= 0.1                         

model MarkowitzModel "Markowitz mean-var model" /All /;
                                                   
muP=0.01;
solve MarkowitzModel minimizing sigmaSqrP using nlp  ;

options Decimals =8;

display X.L,short.l, sigmaSqrP.L;