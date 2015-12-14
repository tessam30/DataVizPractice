
clear
capture log close
*log using "StataTrainingDay2.log", replace

*Import the data
import delimited C:\Users\t\Documents\GitHub\DataVizPractice\fa.planned.csv

* Describe variables
describe

* Check for missing observations
mdesc
mvencode 

* Identify a unique id or create one
* There are no single variables that uniquely identify each observation
* Let's create one:
isid fiscalyear accountname agencyname operatingunit amount


* ================= *
* Tabulations 		*
* ================= *

* Tabulate string variables 
* Review missing data and why it's important to check for this in tabulations
* Also discuss difference between sort and unsorted tabulations
tab fiscalyeartype, sort mi
tab accountname, sort mi
tab agencyname, sort mi
tab agencyname, mi
tab operatingunit, sort mi
tab category, sort mi
tab sector, sort mi

* Faster way
foreach x of varlist fiscalyeartype accountname agencyname category {
	tab `x', sort mi
	}
*end

* ================= *
* Missing Variables *
* ================= *

* Let's check if there are any variables with missing values
mdesc
list if category == ""

* Should we drop these? Yes, for now because we want to create sector shares
drop if category == ""

* How can we check whether or not our drop command worked?
assert category !=""
*assert category ==""
list if category == ""
mdesc category

* ================= *
* Subsetting		*
* ================= *
* Keep only planned observations that belong to USAID
keep if agencyname == "DOS and USAID" | agencyname == "DoD" | agencyname == "IAF" | agencyname == "Treasury"
tab agencyname, mi

* Much more powerful command that we can use to make our life easier
help regexm
keep if regexm(agencyname, "(USAID|DoD|IAF|Treasury)")==1
tab agencyname, mi

tab category fiscalyear
tab category fiscalyear if fiscalyear == 2011, mi

* Two other powerful ways to subset data using functions
help inlist
table category fiscalyear if inlist(fiscalyear, 2006, 2007, 2011, 2012) == 1, c(sum amount) f(%14.0fc)

help inrange
table category fiscalyear if inrange(fiscalyear, 2010, 2014) == 1, c(sum amount) f(%14.0fc)




* ================= *
* Exploring data	*
* ================= *
* Look at the range of planned spending
sum amount
sum amount, detail

* Graph the distribution of amount
histogram amount, normal

* First, let's reformat our data so it is a bit easier to read
format amount %14.0fc

* The data are highly skewed by a few outliers, let's look at these outliers in detail
* First, we'll identify the value of the largest outlier by year
table fiscalyear, c(max amount min amount) 

* So we know the max value, let's look at which agency is responsible
table fiscalyear agencyname, c(max amount) 

* Let's look at all records with more than $1B in planned spending
list fiscalyear agencyname  operatingunit category amount if /*
*/ amount >= 1000000000 & amount != .

list fiscalyear agencyname  operatingunit category amount if inrange(amount, 1000000000, 4000000000) 

* Let's sort our data and then look at it in a clean table
gsort -amount -fiscalyear
list fiscalyear agencyname operatingunit category amount /*
*/ if inrange(amount, 1000000000, 4000000000) == 1 & regexm(agencyname, "USAID") == 1, noo compress


* How should we deal w/ outliers? 1) We could divide everything through by 1M and report
* figures in the millions or we can take a logarithmic transformation which would report
* everything? Do people really think in log terms?
generate amount_millions = (amount / 1000000)
histogram amount_millions

************
* Exercise * 
************





