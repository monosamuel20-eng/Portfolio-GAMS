use gdp_clean.dta, clear

merge 1:1 year using unemployment_clean.dta
drop _merge

merge 1:1 year using cpi_annual.dta
drop _merge

merge 1:1 year using poverty_clean.dta
drop _merge


save argentina_panel.dta, replace

*Generating desired variables*

gen gdp_growth = (gdp - L.gdp) / L.gdp * 100

gen inflation = (cpi - L.cpi) / L.cpi * 100

gen unemp_change = D.unemployment

gen ln_gdp = log(gdp)
gen ln_cpi = log(cpi)
gen ln_unemp = log(unemployment)

*Test for stationarity*

dfuller ln_gdp
dfuller ln_cpi
dfuller ln_unemp
dfuller poverty_rate

*Change to panel into stationarity*

gen d_ln_gdp = D.ln_gdp
gen d_ln_cpi = D.ln_cpi
gen d_ln_unemp = D.ln_unemp
gen d_pov = D.poverty_rate

dfuller d_ln_gdp
dfuller d_ln_cpi
dfuller d_ln_unemp
dfuller d_pov

*summary statistics*
tabstat gdp gdp_growth unemployment unemp_change cpi d_ln_cpi poverty_rate, ///
       stats(mean sd min max n) columns(statistics)
	   
*correlation*	   

pwcorr ln_gdp inflation unemployment poverty_rate, sig star(0.05) obs

*Generating variable charts*

tsline ln_gdp inflation unemployment poverty_rate, ///
    title("Macroeconomic Indicators of Argentina (1995–2025)") ///
    legend(order(1 "ln(GDP)" 2 "Inflation" 3 "Unemployment" 4 "Poverty Rate")) ///
    lcolor(navy maroon forest_green orange_red) ///
    lwidth(medthick medthick medthick medthick)
	
*Generating Dummy variables*	
	
	gen post_crisis = year >= 2003
label variable post_crisis "Post-2001 Crisis Period (1 = 2003+, 0 = 1995–2002)"


*Running our model through regression*

*Main Model
reg ln_gdp ///
    c.d_ln_cpi##i.post_crisis ///
    c.unemp_change##i.post_crisis ///
    c.poverty_rate##i.post_crisis, robust

	reg ln_gdp post_crisis unemp_change poverty_rate, robust

*Recovery magnititude*

reg gdp_growth post_crisis, robust

*Labour Market Recovery*
reg unemployment post_crisis, robust

*
reg poverty_rate post_crisis, robust



egen z_gdp = std(ln_gdp)
egen z_inflation = std(inflation)
egen z_unemployment = std(unemployment)
egen z_poverty = std(poverty_rate)

twoway ///
(line z_gdp year, sort) ///
(line z_inflation year, sort) ///
(line z_unemployment year, sort) ///
(line z_poverty year, sort), ///
xline(2002, lpattern(dash)) ///
legend(order(1 "Log GDP" 2 "Inflation" 3 "Unemployment" 4 "Poverty")) ///
title("Argentina's Macroeconomic Performance, 1995–2025")

tsline gdp_growth

dfuller ln_gdp
dfuller unemployment
dfuller poverty_rate

*Test for collinearity*

	reg ln_gdp post_crisis unemp_change poverty_rate
estat bgodfrey
	reg ln_gdp post_crisis unemp_change poverty_rate, robust

*Test for heteroskedasticity *

	reg ln_gdp post_crisis unemp_change poverty_rate
estat hettest

reg ln_gdp post_crisis unemp_change poverty_rate
estat ovtest

ttest ln_gdp, by(post_crisis)
ttest unemployment, by(post_crisis)
ttest poverty_rate, by(post_crisis)


estat vif

predict residuals, r
qnorm residuals





