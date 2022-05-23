{smcl}
{* *! version 1.0.0  17October2018}{...}
{cmd:help mposim}
{hline}

{title:Title}

{p2colset 5 24 26 2}{...}
{p2col :{cmd:mposim} {hline 1}} Command reproduces neutral distribution shift poverty projections a la MPO. Command requires that sp_groupfunction & groupfunction be installed beforehand.{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 23 2}
{opt mposim}{cmd:,}
{opt weight(varlist numeric max=1)}
{opt welfare(varlist numeric)}
{opt GDPgrowth(numlist min=1)}
{opt PASSthru(numlist max=1)}
{opt YEARstart(numlist max=1)}
{opt thold(numlist max=1)}
{opt tholdvar(varlist max=1 numeric)}
{opt ratio(varlist max=1 numeric)}
{opt povname(string)}

{title:Description}

{pstd}
{cmd:mposim} Command reproduces neutral distribution shift poverty projections a la MPO.  

{title:Options}

{phang}
{opt weight(varlist)} Population expansion factor for poverty estimation.

{phang}
{opt welfare(varlist numeric)} Welfare variable to be used for poverty calculation.

{phang}
{opt GDPgrowth(numlist)} Annual ordered list of values of GDP projected growth, absolute value between 0 and 1.

{phang}
{opt PASSthru(numlist)} Pass through rate for GDP growth. Welfare is adjusted by (1+gdp*passthru)

{phang}
{opt YEARstart(numlist)} Indicates what year does the data correspond to.

{phang}
{opt thold(numlist)} Indicates the threshold for calculating the poverty rate.

{phang}
{opt tholdvar(varlist numeric)} Variable with the threshold for calculating the poverty rate

{phang}
{opt ratio(varlist numeric)} Variable with which the welfare variable is multiplied, useful from converting from one equvalence scale to another. Optional.

{phang}
{opt povname(string)} Prefix to be given to poverty rates. Optional, default is pline.

{title:Example}

datalibweb, country(arm) latesty type(gpwg)

local gdpgrowth .05 -.025 .01

gen usd_ppp = welfare/(cpi2011*icp2011)

mposim,weight(weight) welfare(usd_ppp) gdp(`gdpgrowth') pass(0.87) ///
year(2017) thold(`=365*3.2') 

{title:Authors}

{pstd}
Paul Corral{break}
The World Bank - Poverty and Equity Global Practice {break}
Washington, DC{break}
pcorralrodas@worldbank.org{p_end}

{title:Disclaimer}

{pstd}
Any error or omission is the author's responsibility alone.

