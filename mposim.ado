*!mposim October, 17 2018
* Paul Corral (World Bank Group - Poverty and Equity Global Practice - Equity Policy Lab)

cap prog drop mposim
cap set matastrict off

program define mposim, eclass
	version 13
	#delimit;
	syntax [if] [in],
	weight(varlist max=1 numeric)
	welfare(varlist numeric)
	GDPgrowth(numlist min=1)
	PASSthru(numlist max=1)
	YEARstart(numlist max=1)
	[
	thold(numlist max=1)
	tholdvar(varlist max=1 numeric)
	ratio(varlist max=1 numeric)
	povname(string)
	]
	;
#delimit cr
qui{
	if ("`povname'"=="") local povname pline
	if ("`thold'"!="" & "`tholdvar'"!=""){
		dis as error "Only one option, thold or tholdvar can be specified"
	}
	if ("`thold'"!="")	local Z `thold'	
	if ("`tholdvar'"!="") local Z `tholdvar'
	
	local sz: list sizeof gdpgrowth
	tokenize `gdpgrowth'
	
	if (abs(`passthru')>1) {
		dis as error "Values for passthru are over 1, please check"
		error 198
		exit
	}
	
	local gdp = 1
	local cummul = 1
	forval z= `yearstart' / `=`yearstart'+`sz'' {
		tempvar y_`z'
		if (`z'==`yearstart') gen double `pref'_`z' = `Z'
		else{
			if (abs(``gdp'')>1) {
				dis as error "Values for GDP growth are over 1, please check"
				error 198
				exit
			}
			local cummul = `cummul'*(1+``gdp''*`passthru')
			gen double `pref'_`z' = `Z' / `cummul'
			local ++gdp		
		}
		
		local lineas `lineas' `pref'_`z'
	}
	
	if ("`ratio'"!=""){
		replace `welfare' = `welfare'*`ratio'	
	}
	
	tempvar all
	gen `all' = 1
	sp_groupfunction [aw=`weight'], poverty(`welfare') povertyline(`lineas') by(`all')
	drop `all'
	gen year = real(subinstr(reference,"_","",.))
	drop reference
	sort measure year
}
end
