# PURPOSE ---------

#   Function to determine tier 1 ratio.

# PREPARED BY ------

# Chris Poulos

# 2022-10-19

# bring in ebf_base_calc dataframe ----

source("scripts/ebf_base_calc.R")

# This will return a sum of the optimal cut off percent. 
# It does so by summing the funding gap model - 
# sum of (tier 1 target ratio * final adequacy level)-final resources for each 
# district below the cut off percent selected.

gap <- function(y) {
  ebf_base_calc$t1cutoff <- case_when(ebf_base_calc$adequacy_funding_level < y ~ ((y*ebf_base_calc$final_adequacy_target)-ebf_base_calc$final_resources),
                                FALSE ~ 0)
  return(sum(ebf_base_calc$t1cutoff, na.rm = TRUE))
}

# Set the variables for tier funding - only hard code the statutorily set
# variables and the new allocation amount (subject to change via the 
# legislature each year).

naa <- 300000000 # new appropriation allocation
t1naa <- naa*.5 # tier 1 new appropriation allocation (50% of NAA, statutorily set)
t1fg <- t1naa/.3 # tier 1 funding gap, which is equal to the  (30% of funding gap)

# This plugs in percentages from 0 to 1 until it finds the optimal cut off, 
# which is the funding gap (see below for equation) minus x (the funding gap)
# so that the optimal percent is when the gap minum the gap = 0

targetratio <- function(x, lower, upper) {
  optimize(function(y) abs(gap(y) - x), lower=lower, upper=upper, tol = 0.000000000000000000000000000000000000000000000000000000000001)
}

# This finals 

targetratio(t1fg, # set the first number as the total tier 1 funding gap = (new appropriation allocation*.5)/.3, in other words the new tier 1 funding (half of the new allocation amount, that's statutory) divided by the tier 1 allocation rate (30% which is statutory) 
   0.00000000000000, # the low point to be searched (0% adequacy level cut off)
   1) # the high point to be searched (100% adequacy level cut off)

gap(0.6942345) # test out the the funding adequacy level cut off

print(t1fg - gap(0.6942345)) # this will tell you how off we are

