 clear
 import delimited C:\Users\t\Documents\GitHub\DataVizPractice\food.court.dates.csv

ren v7 monthNum
ren v10 dayName
tab month
replace month = "May" if month == "May "
la var year "year"

* Create a time variable so Stata can read as dates
g double date_Stata = clock(timevalue, "MD20Yhm")
format date_Stata %tc
isid date_Stata

* Time series set the data
tsset date_Stata
tsline visitors
gen dow = dow(mdy(monthNum, day, year))

* Calculate statistics for day of week, month, and day of month
egen monthTotal = total(visitors), by(month year)
egen monthAve = mean(visitors), by(month year)
egen dayTotal = total(visitors), by(dayName month year)
egen dayAve = mean(visitors), by(dayName month year)
egen dayMonthTotal = total(visitors), by(day month year)
egen dayMonthAve = mean(visitors), by(day month year)

egen dailyTotal = total(visitors), by(day month year)
egen dailyAve = mean(visitors), by(day month year)

tsline dailyAve
tsline dayMonthTotal
tsline dayMonthAve
reg visitors i.monthNum i.year i.dow, robust

table monthNum year, c(mean visitors sum visitors) f(%9.0fc)
