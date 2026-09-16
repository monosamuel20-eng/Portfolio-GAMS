Sets
  Assets(*)
  Scenarios(*);
  
Parameters
   mu(*)
   r(*,*);
   
$GDXIN 'YahooIndexes.gdx'
$LOAD Assets mu=ExpectedReturns r=ReturnScenarios
$LOAD Scenarios
$GDXIN

Alias (Assets, i, j);
Alias(Scenarios, s);
Set ss(s) /SS_1 * SS_100/;

Scalars
  gamma /2.0/       
  Equity /1000000/;

Positive Variables
  ROE(ss)
  x(i);
  
Variables
  EU;            
    
Equations
   BudgetCon
   ROEEq(ss)
   ExpectedUtility;
   
* Budget Constraint: Sum of invested assets X_i = E
BudgetCon.. sum(i, x(i)) =E= Equity;

ROEEq(ss).. ROE(ss) =E= sum(i, (x(i))* (1.0+r(ss, i))) /Equity;

ExpectedUtility.. EU =E= (1.0/card(ss)) * sum(ss, ((ROE(ss)**(1-gamma)-1)/(1-gamma))$(gamma <> 1) +(log(ROE(ss)))$(gamma = 1));



Model UtilityModel /all/;
ROE.LO(ss) =0.01

Solve UtilityModel maximizing EU using NLP;

Display EU.L, X.L;