use "https://github.com/josekaire/comfortably_numb/raw/master/prolonge%20exposure%20data%20january%2025.dta", clear


****************************************************************
**                                                            **
**                                                            **
** 		                                                      **
** Balance checks                                             **
**                                                            **
**                                                            **
****************************************************************
s
factor onedge tense grouchy blue energetic hopeless uneasy restless unfocused fatigued annoyed angry discouraged resentful nervous miserable cheerful bitter exahusted anxious helpless weary wornout bewildered furious peppy worthless forgetful vigorous uncertain bushed unhappy lively confused peeved sad active, pcf
rotate
predict prefactor1 prefactor2 prefactor3 prefactor4 prefactor5 prefactor6

label var prefactor1 "Anger-Hostility"
label var prefactor2 "Fatigue-Inertia"
label var prefactor3 "Depression-Dejection"
label var prefactor4 "Vigor-Activity"
label var prefactor5 "Tension-Anxiety"
label var prefactor6 "Confusion-Bewilderment"

tab prefactor1 control, chi2
tab prefactor2 control, chi2
tab prefactor3 control, chi2
tab prefactor4 control, chi2
tab prefactor5 control, chi2
tab prefactor6 control, chi2

tab sex control, chi2
tab mediatrust control, chi2
tab education control, chi2
tab polknow control, chi2
tab partyid control, chi2
tab upbring control, chi2


****************************************************************
**                                                            **
**                                                            **
** 		                                                      **
** Factor analysis and ANOVA models for emotions              **
**                                                            **
**                                                            **
**************************************************************** 


factor onedgep tensep grouchyp bluep energeticp hopelessp uneasyp restlessp unfocusedp fatiguedp annoyedp angryp discouragedp resentfulp nervousp miserablep cheerfulp bitterp exahustedp anxiousp helplessp wearyp wornoutp bewilderedp furiousp peppyp worthlessp forgetfulp vigorousp uncertainp bushedp unhappyp livelyp confusedp peevedp sadp activep, pcf
rotate
predict postfactor1 postfactor2 postfactor3 postfactor4 postfactor5 postfactor6

label var postfactor1 "Anger-Hostility"
label var postfactor2 "Fatigue-Inertia"
label var postfactor3 "Depression-Dejection"
label var postfactor4 "Vigor-Activity"
label var postfactor5 "Tension-Anxiety"
label var postfactor6 "Confusion-Bewilderment"

gen diffactor1=postfactor1-prefactor1
gen diffactor2=postfactor2-prefactor2
gen diffactor3=postfactor3-prefactor3
gen diffactor4=postfactor4-prefactor4
gen diffactor5=postfactor5-prefactor5
gen diffactor6=postfactor6-prefactor6

label var diffactor1 "Anger-Hostility differenced"
label var diffactor2 "Fatigue-Inertia differenced"
label var diffactor3 "Depression-Dejection differenced"
label var diffactor4 "Vigor-Activity differenced"
label var diffactor5 "Tension-Anxiety differenced"
label var diffactor6 "Confusion-Bewilderment differenced"

anova diffactor1 control
anova diffactor1 control polknow

anova diffactor2 control
anova diffactor2 control polknow

anova diffactor3 control
anova diffactor3 control polknow

anova diffactor4 control
anova diffactor4 control polknow

anova diffactor5 control
anova diffactor5 control polknow

anova diffactor6 control
anova diffactor6 control polknow




****************************************************************
**                                                            **
**                                                            **
** 		                                                      **
** ANOVA models for Right Wing Authoritarianism               **
**                                                            **
**                                                            **
**************************************************************** 

anova rwa control
anova rwa control polknow

anova rwa2 control
anova rwa2 control polknow

anova rwa3 control 
anova rwa3 control polknow


****************************************************************
**                                                            **
**                                                            **
** 		                                                      **
** ANOVA models for personal risk assessments                 **
**                                                            **
**                                                            **
**************************************************************** 


anova attackUS control
anova attackUS control polknow

hist attackUS

gen sqrtattackUS=sqrt(attackUS)

anova sqrtattackUS control
anova sqrtattackUS control polknow

anova attackself control
anova attackself control polknow

anova attackacq control
anova attackacq control polknow

anova confprev control
anova confprev control polknow

anova confprot control
anova confprot control polknow


****************************************************************
**                                                            **
**                                                            **
** 		                                                      **
** Logit models for Defense spending				          **
**                                                            **
**                                                            **
**************************************************************** 

oneway bdefense control
anova bdefense control polknow
ologit bdefense control
ologit bdefense control polknow
*estimates store Borderdefense

oneway defense control
anova defense control polknow
ologit defense control
ologit defense control polknow
*estimates store Defensespending

oneway for_aid control
anova for_aid control polknow
ologit for_aid control
ologit for_aid control polknow
*estimates store Foreignaid

oneway home_secure control
anova home_secure control polknow
ologit home_secure control
ologit home_secure control polknow
*estimates store Homelandsecurityspending

*esttab Borderdefense Defensespending Foreignaid Homelandsecurityspending using "C:\Users\ahoffman\Documents\local\Research\Terrorism\media coverage\Repeated exposure study\self report results Defense spending 28 April 2015.csv", cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01)
*coefplot Borderdefense ||Defensespending ||Foreignaid ||Homelandsecurityspending, drop(_cons) xline(0) ci(95) rename (control=Prolonged_exposure)
*graph save "C:\Users\ahoffman\Documents\local\Research\Terrorism\media coverage\Repeated exposure study\Defense spending coefplot graph 28 April 2015.gph"




