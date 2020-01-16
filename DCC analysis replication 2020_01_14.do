*Replication Comfortably Numb: Effects of Prolonged Media Coverage. Journal of Conflict Resolution
*Aaron Hoffman & José Kaire 
*DCC analysis
*1/14/2020
*Load data from Github repository
use "https://github.com/josekaire/comfortably_numb/raw/master/DCC%20analysis%202020_01_14.dta", clear

*Figure 2: Graph of series 
label define seconds 100  "10"	200  "20"	300  "30"	400  "40"	500  "50"	600  "60"	700  "70"	800  "80"	900  "90"	1000  "100"	1100  "110"	1200  "120"	1300  "130"	1400  "140"
label value ds seconds 

twoway (tsline valencefirst, lpattern(dash) lcolor(black) xlabel(#15, labels) , if valencelast!=.) (tsline valencelast, lcolor(gray), if valencefirst!=.), /// 
 legend(order(1 "Commencement series"  2 "Coda series"))  graphregion(color(white )) ///
 ytitle("Valence score") xtitle("Seconds in video") xlabel(#15, valuelabels) xmtick(##9) 
 
*DCC analysis 
mgarch dcc (valencefirst=, arch(1)) (valencelast=, arch(1 ) garch(1))
estat ic
predict R*, variance 
predict H*, variance 

*Figure 3: DCC graph 
gen dcc=H_valencelast_valencefirst*24 /*Muliply the quasicorrelations by Rbar to get actual correlations*/
label variable dcc "Dynamic conditional correlaitons"
tsline dcc, xtitle("Seconds in video") xlabel(#15, valuelabels) xmtick(##9)  ymtick(##4) graphregion(color(white ))

*********************************
* Preliminares for DCC analysis *
* 		(see appendix)          *
*********************************
gen dfirst=d1.valencefirst	/* Compare standard deviations */
gen dlast=d1.valencelast 
sum valencefirst
sum dfirst	
sum valencelast
sum dlast	

global format1 ytitle("Autocorrelations of commencement series")  graphregion(fcolor(white))   mcolor("black")  lcolor("black")
global format2 ytitle("Partial autocorrelations of commencement series") graphregion(fcolor(white))   mcolor("black")  lcolor("black")

ac valencefirst, name(acf, replace) lag(30)  $format1 /*Does the ACF show integration*/
pac valencefirst, name(pacf, replace) lag(30) $format2 /*Does the ACF show integration*/
graph combine acf pacf, xsize(6.5) graphregion(fcolor(white))  
dfuller valencefirst	/*DF test */ 
dfuller valencelast	/*DF test */ 

arima valencefirst, arima(1,0,0) /*Fit an AR(1) process */
predict AR, r
arima valencefirst, arima(2,0,0) /*Fit an AR(1) process */
predict AR2, r
arima valencefirst, arima(3,0,0) /*Fit an AR(1) process */
predict AR3, r

ac AR1 
pac AR1
drop AR1
*Look at the ACF/PACF last

global format3 ytitle("Autocorrelations of coda series")  graphregion(fcolor(white))   mcolor("black")  lcolor("black")
global format4 ytitle("Partial autocorrelations of coda series") graphregion(fcolor(white))   mcolor("black")  lcolor("black")
ac valencelast, name(acf, replace) lag(30) $format3
pac valencelast, name(pacf, replace) lag(30) $format4
graph combine acf pacf, xsize(6.5) graphregion(fcolor(white))  

arima valencelast, arima(1,0,0) /*Fit an AR(1) process */
predict AR1, r 
arima valencelast, arima(1,0,1) /*Fit an ARMA process */
predict ARMA1, r
arima valencelast, arima(1,0,2) /*Fit an ARMA process */
predict ARMA2, r
arima valencelast, arima(1,0,3) /*Fit an ARMA process */
predict ARMA3, r
arima valencelast, arima(1,0,5) /*Fit an ARMA process */
predict ARMA5, r

ac ARMA3
pac ARMA1
}
*Engle LM test 
{
twoway (line AR seconds, sort), name(gAR, replace) title("Commencement series")  /// 
 ytitle("Residuals after fitting an AR(1)") xtitle("Seconds in video") xlabel(#10, valuelabels) xmtick(##9) graphregion(color(white ))
twoway (line ARMA1 seconds, sort), name(gARMA, replace) title("Coda series") /// 
ytitle("Residuals after fitting an ARMA(1, 0, 1)") xtitle("Seconds in video") xlabel(#10, valuelabels) xmtick(##9) graphregion(color(white ))
graph combine gAR gARMA, graphregion(color(white ))


regress AR 
estat archlm, lags(1/15) 
arch valencefirs, ar(1) arch(1)
***End
