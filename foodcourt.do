
replace time_of_day ="" if time_of_day =="#VALUE!"
replace time = subinstr(time, " PM", "", .)
replace time = subinstr(time, " AM", "", .)
drop if time == "FOOD COURT CLOSED"
drop if time == "FOOD COURT "

clonevar time2 = time
replace time2 = subinstr(time2, ":", "", .)
destring time2, replace
replace time2 = time2 + 1200 if time_of_day == "PM" & time2 >=100 & time2 <= 1000

gen double mdate = monthly(month , "M")
gen dow = dow( mdy( month, day, year) )
