*!seclabsim October, 17 2018
* Paul Corral (World Bank Group - Poverty and Equity Global Practice - Equity Policy Lab)

cap prog drop mposim
cap set matastrict off

program define mposim, eclass
	version 13
	#delimit;
	syntax [if] [in],
	weight(varlist max=1 numeric)
	welfare(varlist max=1 numeric)
	GDPgrowth(numlist min=1)
	PASSthru(numlist max=1)
	keepv(varlist min=1)
	YEARstart(numlist max=1)
	[
	thold(numlist max=1)
	tholdvar(varlist max=1 numeric)
	]
	;
#delimit cr
qui{

if ("`thold'"!="" & "`tholdvar'"!=""){
	dis as error "Only one option, thold or tholdvar can be specified"
}
if ("`thold'"!="") local Z `thold'
if ("`tholdvar'"!="") local Z `tholdvar'
	
	local sz: list sizeof gdpgrowth
	
	forval z= `yearstart' / `=`yearstart'+`sz'' {
		tempvar y_`z'
		if (`z'==`yearstart') gen double `y_`z'' = `welfare'
		else        gen double `y_`z'' = .
		
	}
	
	local a = `yearstart'
	foreach gdp of local gdpgrowth{
		local _y=`a'+1
		local adjustment = (1+`gdp'*`passthru')
		
		replace `y_`_y'' = `y_`a''*`adjustment'
		
		noi:sum `y_`_y''
		
		local myvars `myvars' `y_`_y''
		
		local ++a	
	}
	
	keep `keepv' `welfare' `myvars' `weight'
	
	local a = `yearstart'
	rename `welfare' `welfare'_`a'
	foreach x of local myvars{
		local _y=`a'+1
		rename `x' `welfare'_`_y'
		local ++a
	}
	
	local a = `yearstart'
	foreach gdp of local gdpgrowth{
		local _y=`a'+1
		char _dta[_`_y'] = `gdp'
		local ++a
	}
	
	if ("`Z'"!=""){
		foreach x of varlist `welfare'*{
			local nm = subinstr("`x'","`welfare'_","",.)
			gen fgt0_`nm' = `x' < `Z' if !missing(`x')
		}
		gen all=1
		groupfunction [aw=`weight'], mean(fgt0_*) by(all)
		reshape long fgt0_, i(all) j(year)
		gen pthru = `passthru'
	}
	
}
end

