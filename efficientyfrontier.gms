* INPUT DATA SECTION

SET Stocks(*);

SET EfficientFrontierPoints /PP_1 * PP_30/;

ALIAS(EfficientFrontierPoints,p);

PARAMETERS mu(*);

PARAMETERS sigma(*,*);

PARAMETERS beta(*);

$GDXIN 'DJ.gdx'

$LOAD Stocks=i mu=ExpectedReturns
$LOAD sigma=VarCov
$LOAD beta
$GDXIN

ALIAS(Stocks,i,j);

SCALARS
      mu_min
      mu_max
      mu_step
      muP;

mu_min = -0.01;
mu_max = 0.03;

mu_step = (mu_max - mu_min) / (CARD(p)-1);

PARAMETER
      muValues(p);
      
 muValues(p) = mu_min + (ORD (p)-1) * mu_step ;

OPTION DECIMALS = 8;
Display mu_step, muValues;

$EXIT

SCALAR muP;
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
              
Parameter
   Frontier(p, *)
   optimalPortafolios(p,i);
   
loop(p,
   muP = muValues
   solve MarkowitzModel minimizing sigmaSqrP using nlp
OptimalPortafolios(p,i)

Frontier(p, "Portafolio Return")= muP;
Frontier(p, "Portafolio Variance")= SigmaSqrP.l;
OptimalPortfolios(p, i) = X.L(i);

);
                                     
muP=0.01;
solve MarkowitzModel minimizing sigmaSqrP using nlp  ;

options Decimals =8;

display Frontier, OptimalPortfolios;

execute_unload "Results.gdx", Frontier, OptimalPortfolios;
execute 'gdxxrw.exe results.gdx 0=result.xlsx par=Frontier rng=frontier!a1' ;
execute 'gdxxrw.exe Results.gdx O=Result.xlsx par=OptimalPortfolios rng=weights!A1';