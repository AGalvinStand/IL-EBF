options(scipen = 999)

# load -------
library(shiny)
library(shinythemes)
library(shinydashboard)
library(shinyBS)
library(htmltools)
library(DT)
library(leaflet)
require(scales)
library(plotly)
library(tidyverse)

ebf_base_calc_conpov <- read_rds("data/ebf_base_calc_conpov.rds")
ebf_base_calc <- read_rds("data/ebf_base_calc.rds")


ebfsim <- ebf_base_calc_conpov

gap <- function(y) {
  ebfsim$t1cutoff <- case_when(ebfsim$final_percent_adequacy < y ~ ((y*ebfsim$final_adequacy_target)-ebfsim$final_resources),
                               FALSE ~ 0)
  return(sum(ebfsim$t1cutoff, na.rm = TRUE))
}

# Set the variables for tier funding - only hard code the statutorily set
# variables and the new allocation amount (subject to change via the
# legislature each year).

# Determine total adequacy gap

total_adequacy_gap <- sum(ebfsim$final_adequacy_target) - sum(ebfsim$final_resources)

goal_year <-2027

# #TEST
#
# goal_year <- 2027
#
# #END TEST

current_year <- as.numeric(format(Sys.time(), "%Y"))

years_to_goal <- goal_year - current_year

# minimum_yearly_funding <- total_adequacy_gap/years_to_goal

minimum_yearly_funding <- 300000000

naa <- minimum_yearly_funding # new appropriation allocation (if we want full funding by specified date)
t1funding <- naa*.5 # tier 1 new appropriation allocation (50% of NAA, statutorily set)
t1fg <- t1funding/.3 # tier 1 funding gap, which is equal to the  (30% of funding gap)
t2funding <- naa*.49
t3funding <- naa*.009
t4funding <- naa*.001

tier1_far <- 0.3 # This is set by legislation (The funding allocation ratio)

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

# Tier cut offs

tier1 <- as.numeric(t1tr)
tier2 <- 0.90
tier3 <- 1.00

df <- ebfsim |>
  
  mutate(tiers = case_when(final_percent_adequacy < as.numeric(t1tr) ~ 1,
                           final_percent_adequacy > as.numeric(t1tr) & final_percent_adequacy < .9 ~ 2,
                           final_percent_adequacy > .9 & final_percent_adequacy < 1 ~ 3,
                           final_percent_adequacy > 1 ~ 4,
                           FALSE ~ 0)) |>
  mutate(t1fundinggap = case_when(tiers == 1 ~ (t1tr*final_adequacy_target)-final_resources,
                                  TRUE~0)) |>
  mutate(t1funding = case_when(tiers == 1 ~ t1fundinggap * .3,
                               TRUE~0)) |>
  
  # .9 is the tier 2 ratio
  
  mutate(tier2_funding_gap = case_when(tiers < 3 ~ ((.9*final_adequacy_target)-final_resources-t1funding)-(1- local_cap_ratio_capped90),
                          TRUE~0)) |>
  
  
  # Adequacy funding gap 
  
  mutate(adequacy_funding_level =
           final_resources / final_adequacy_target) |> 
  
  # Adequacy Funding Level
  
  mutate(adequacy_funding_level =
           final_resources / final_adequacy_target) |> 
  
  # Assign tiers based on Adequacy Funding Level
  
  mutate(tier =
           case_when(adequacy_funding_level < as.numeric(t1tr) ~ 1,
                     adequacy_funding_level < .9 & adequacy_funding_level >= as.numeric(t1tr) ~ 2,
                     adequacy_funding_level < 1 & adequacy_funding_level >= .9 ~ 3,
                     adequacy_funding_level >= 1 ~ 4)) |>
  
  # Flag tier 1
  
  mutate(tier1flag =
           case_when(tier == 1 ~ 1,
                     tier > 1 ~ 0)) |>
  
  mutate(tier3finaladequacy = 
           case_when(tier == 3 ~ final_adequacy_target,
                     TRUE~0),
         tier4finaladequacy = 
           case_when(tier == 4 ~ final_adequacy_target,
                     TRUE ~ 0)) |>
  # Tier 1 funding gap
  
  mutate(tier1_funding_gap =
           ((as.numeric(t1tr)*final_adequacy_target)-final_resources) * tier1flag) |>
  
  # Tier 1 funding
  
  mutate(tier1_funding = tier1flag * (tier1_funding_gap*.3)) |> # 30% allocation rate is set by legislation (The funding allocation ratio)
  mutate(tier1_perpupil =
           ifelse(total_ase > 0,
                  tier1_funding/total_ase,
                  0)) |>
  
  # Tier 2 funding gap
  
  mutate(tier2_funding_gap =
           case_when(tier == 1 | tier ==2 ~ ((.9*final_adequacy_target)-final_resources-tier1_funding_gap)*(1-local_cap_ratio_capped90),
                     TRUE ~ 0))

# ar = allocation rate

  t4ar <- as.numeric(t4funding)/sum(df$tier4finaladequacy)
  t3ar <- as.numeric(t3funding)/sum(df$tier3finaladequacy)
  
  t2fg <- sum(df$tier2_funding_gap)
  
  t2ar <- t2funding/t2fg
  

  dfw <- df |>
  
  # Tier 3 funding
  
  mutate(tier3_funding =
           case_when(tier == 3 ~ final_adequacy_target*(t3ar), # t3funding/sum(tier3finaladequacy) = tier 3 funding allocation ratio
                     TRUE ~ 0)) |>
  
  mutate(tier3_perpupil =
           case_when(total_ase>0 ~ tier3_funding/total_ase,
                     TRUE ~ 0)) |>
  
  # Tier 4 funding
  
  # tier4allocationrate <- t4funding/sum(df$tier4finaladequacy)
  
  mutate(tier4_funding =
           case_when(tier == 4 ~ final_adequacy_target*t4ar, # t4funding/sum(tier4finaladequacy) = tier 4 funding allocation ratio
                     TRUE ~ 0)) |>
  
  mutate(tier4_perpupil =
           case_when(total_ase>0 ~ tier4_funding/total_ase,
                     TRUE ~0)) |>
  
  
  # Tier 2 funding
  
  # Step 1
  
  mutate(tier2_funding_step1 =
           case_when(tier == 1 | tier == 2 ~ tier2_funding_gap * t2ar,
                     TRUE~0)) |>

  # Original Tier 2 Per Student
  
  mutate(tier2_perpupil_orig =
           case_when(total_ase>0 ~ tier2_funding_step1/total_ase,
                     TRUE ~ 0)) |>
  # Step 2
  
  mutate(tier2_funding_step2 =
           case_when(tier == 2 & tier2_perpupil_orig<as.numeric(max(tier3_perpupil)) ~ as.numeric(max(tier3_perpupil))*total_ase, # max(tier3_perpupil) Tier 3 Maximum Funding Per Student for Purposes of Caclulating Final Tier 2 Funding
                     TRUE ~ tier2_funding_step1))
  
  revisedstep2 <- sum(dfw$tier2_funding_step1)/sum(dfw$tier2_funding_step2)
  
  dfw1 <- dfw |>
  
  # Step 3
  
  mutate(tier2_funding_step3 =
           tier2_funding_step2 * revisedstep2) |> # FLAGGING THIS - This is a revision in the EBF calculation, unsure what it is
  
  # Final Tier 2 Per Student
  
  mutate(tier2_perpupil_final =
           case_when(total_ase>0 ~ tier2_funding_step3/total_ase,
                     TRUE ~ 0)) |>
  
  # Calculating total state contribution
  
  
  # Calculated new FY Funding
  
  mutate(new_fy_funding =
           tier1_funding +
           tier2_funding_step3 +
           tier3_funding +
           tier4_funding) |>
  
  # Calculated new FY Funding (per pupil)
  
  mutate(new_fy_funding_perpupil =
           case_when(total_ase >0 ~ new_fy_funding/total_ase,
                     TRUE ~ 0)) |>
  
  # Total gross state FY contribution
  
  mutate(gross_fy_funding =
           new_fy_funding +
           base_funding_minimum) |>
  
  mutate(tier_text = case_when(tier == 1 ~ "One",
                               tier == 2 ~ "Two",
                               tier == 3 ~ "Three",
                               tier == 4 ~ "Four",
                               TRUE ~ "WHAT"))


print("dun")

df2 <- dfw1|>
  group_by(tier_text) |>
  summarise(tier = mean(tier),
            new_fy_funding = sum(new_fy_funding),
            total_ase = sum(total_ase)) |>
  mutate(new_funding_perpupil = new_fy_funding/total_ase)

ggplotly(
  ggplot(df2,
         aes(x=tier,y=new_funding_perpupil)) +
    geom_col() +
    scale_y_continuous(labels = dollar_format(), limits = c(0,200000)) +
    theme_bw())
