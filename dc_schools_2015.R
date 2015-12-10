# Steps to grabbign DC schools data

#1) copy data from webpage (http://www.myschooldc.org/schools/)
#2) paste in excel (1640 rows), clean up in excel (search for skip patterns -- test scores missing)
#3) copy to clipboard and read clipboard
#4) convert to matrix and reshape
#5) save as .csv and clean up formatting in excel



library(ramify)
x <-readClipboard()
dim(x)

d <- as.matrix(x)
dc_schools <- matrix(x, 211, 8, byrow = TRUE)

write.csv(dc_schools, file = "dc_schools_2015.csv")





