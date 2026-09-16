set
  Assets(*)
  Scenarios(*);
  
Parameters
   mu(*)
   r(*,*);
   
$GDXIN 'YahooIndexes.gdx'

$LOAD Assets mu= ExpectedReturns r=ReturnScenarios
$LOAD Scenarios
$GDXIN


Alias (Assets, i, j);
Alias(Scenarios, s)
set ss(s) /SS_1 * SS_100/;

scalar
alpha /0.95/
c /1000000/;

Positive Variables
    x(i)
    y(ss);
  
Variables
    z
    vaR
    Losses
    Vp(ss);
    
Equations
   PorfolioLosses(ss)
   ConditionalVarEq
   VarDevEq(ss)
   PortfolioValueEq(ss)
   budgetCon
   ExpentedReturn;
   
PorfolioLosses(ss)..Losses(ss) =E= -(Vp(ss)-c);
PortfoliovalueEq(ss).. Vp(ss) =E= sum(i, x(i)*(1.0+r(ss,i)));
BudgetCon.. sum(i, x(i))=E= c;
VarDevEq(ss).. y(ss) =G= losses(ss) -VaR;
ConditionalVarEq.. z =E= VaR + (1.0/(1.0-alpha))*sum(ss, y(ss));
ExpentedReturn.. (1.0/c)* sum(i, x(i)* mu(i))=E= 0.015;

model conditionalVaR /all/;
solve conditionalVaR minimizing z using LP;
display x.L, VaR.L;
