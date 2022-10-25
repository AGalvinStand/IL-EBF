# PURPOSE ---------

#   Function to determine tier 1 ratio.

# PREPARED BY ------

# Chris Poulos

# 2022-10-19

# bring in ebf_base_calc dataframe ----

source("scripts/ebf_base_calc.R")

# tier 1 target ratio threshold function

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
t1funding <- naa*.5 # tier 1 new appropriation allocation (50% of NAA, statutorily set)
t1fg <- t1funding/.3 # tier 1 funding gap, which is equal to the  (30% of funding gap)

# This plugs in percentages from 0 to 1 until it finds the optimal cut off, 
# which is the funding gap (see below for equation) minus x (the funding gap)
# so that the optimal percent is when the gap minum the gap = 0

targetratio <- function(x, lower, upper) {
  optimize(function(y) abs(gap(y) - x), lower=lower, upper=upper, tol = 0.00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001)
}

tr_table <- targetratio(t1fg, # set the first number as the total tier 1 funding gap = (new appropriation allocation*.5)/.3, in other words the new tier 1 funding (half of the new allocation amount, that's statutory) divided by the tier 1 allocation rate (30% which is statutory) 
   0.0000000000000000000000000000000000000000000000000000000000000, # the low point to be searched (0% adequacy level cut off)
   1) # the high point to be searched (100% adequacy level cut off)

t1tr <- tr_table$minimum # Create a variable that pulls the $minimum (i.e the tier 1 target ratio threshold)

gap(t1tr) # test out the the funding adequacy level cut off

print(t1fg - gap(t1tr)) # this will tell you how off we are, it should be 0

# use the target ratio to assign tiers and tier2 funding gap----

ebf_base_calc <- ebf_base_calc |>
  mutate(tiers = case_when(adequacy_funding_level < as.numeric(t1tr) ~ 1,
                           adequacy_funding_level > as.numeric(t1tr) & adequacy_funding_level < .9 ~ 2,
                           adequacy_funding_level > .9 & adequacy_funding_level < 1 ~ 3,
                           adequacy_funding_level > 1 ~ 4,
                           FALSE ~ 0)) |>
  mutate(t1fundinggap = case_when(tiers == 1 ~ (t1tr*final_adequacy_target)-final_resources)) |> 
  mutate(t1funding = case_when(tiers == 1 ~ t1fundinggap * .3)) |>
  mutate(t2fg = case_when(tiers < 3 ~ ((.9*final_adequacy_target)-final_resources-t1funding)-(1- local_cap_ratio_capped90)))


# Calculate tier 2 allocation rate


t2funding <- naa*.49
t2fgsum <- sum(ebf_base_calc$t2fg, na.rm = T)
t2allocationrate <- t2funding/t2fgsum

