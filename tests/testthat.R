# Based on https://github.com/hadley/testthat#integration-with-r-cmd-check 
# which is the limit on travis CI. 
library(testthat)
library(disutils)
test_check("disutils")
