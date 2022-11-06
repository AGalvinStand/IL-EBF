# server.r

# EBF simulator

# Load -------
library(shiny)
library(shinythemes)
# library(shinydashboard)
# library(shinyBS)
# library(htmltools)
# library(DT)
# library(leaflet)
require(scales)
library(plotly)
library(tidyverse)

options(shiny.trace = TRUE)

library(shiny)


shinyServer(function(input, output) {
  
  # Read in dataframes ----
  
  # these 4 inputs will be used to create a reactive dataframe based on the
  # CP and Race UI inputs.
  
  # Data frames:
  
  # 1. CREATE RDS FOR "AS IS" -----
  
  # Add code (as see under #2) here
  
  # 2. EBF with concentrated poverty weights
  
  ebf_base_calc_conpov <- read_rds("data/ebf_base_calc_conpov.rds")
  
  # 3. CREATE RDS FOR Race weights ----
  
  # Add code (as see under #2) here
  
  # 4. CREATE RD FOR Race + Concentrated poverty weights. ----
  
  # Add code (as see under #2) here
  
  # CODE FOR REACTIVE DATA FRAME: -----
  
  #############################################################################
  #############################################################################
  #
  #
  # use "df()" for the reactive dataframe name.
  #
  # If concentrated poverty weight is on, then use 2;
  # else if race weight is on, then use 3;
  # else if cp and race weight is on, then use 4;
  # else use 1.
  #
  #
  ##############################################################################
  ##############################################################################
  
  # Create ebfsim variable ----
  
  # In the following line of code, replace "ebf_base_calc_conpov" with
  # "df()"
  
  # This will make it so the following lines of code use the reactive
  # data frame created above.
  
  ebfsim <- ebf_base_calc_conpov # CONTROL F AND REPLACE "ebf_base_calc_conpov"
  # with "df()"
  
  # create outputs necessary for reactive data based on year ----
  
  # minimum yearly funding = total funding gap minus years to the goal year.
  
  minimum_yearly_funding <- reactive({
    (sum(ebfsim$final_adequacy_target) - sum(ebfsim$final_resources))/(input$years - as.numeric(format(Sys.time(), "%Y")))
  })
  
  
  
  # create reactive dataframe for year input ----------
  
  ebfsim2 <- reactive({
    
    gap <- function(y) {
      ebfsim$t1cutoff <- case_when(ebfsim$final_percent_adequacy < y ~ ((y*ebfsim$final_adequacy_target)-ebfsim$final_resources),
                                   FALSE ~ 0)
      return(sum(ebfsim$t1cutoff, na.rm = TRUE))
    }
    
    # Set the variables for tier funding - only hard code the statutorily set
    # variables and the new allocation amount (subject to change via the
    # legislature each year).
    
    
    naa <- minimum_yearly_funding() # new appropriation allocation (if we want full funding by specified date)
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
    
    # Pre-Stage 3: Determining Tier
    
    # Tier 1 target ratio threshold function
    
    # This will return a sum of the optimal cut off percent.
    # It does so by summing the funding gap model -
    # sum of (tier 1 target ratio * final adequacy level)-final resources for each
    # district below the cut off percent selected.
    
    ebfsim |>
      
      # use the target ratio to assign tiers and tier2 funding gap
      
      
      mutate(tiers = case_when(final_percent_adequacy < as.numeric(t1tr) ~ 1,
                               final_percent_adequacy > as.numeric(t1tr) & final_percent_adequacy < .9 ~ 2,
                               final_percent_adequacy > .9 & final_percent_adequacy < 1 ~ 3,
                               final_percent_adequacy > 1 ~ 4,
                               FALSE ~ 0)) |>
      mutate(t1fundinggap = case_when(tiers == 1 ~ (t1tr*as.numeric(final_adequacy_target))-final_resources)) |>
      mutate(t1funding = case_when(tiers == 1 ~ t1fundinggap * .3)) |>
      mutate(t2fg = case_when(tiers < 3 ~ ((.9*final_adequacy_target)-final_resources-t1funding)-(1- local_cap_ratio_capped90))) |>
      
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
               case_when(tier == 3 ~ as.numeric(final_adequacy_target),
                         TRUE ~ 0),
             tier4finaladequacy = 
               case_when(tier == 4 ~ as.numeric(final_adequacy_target),
                         TRUE ~ 0)) 
    # Tier 1 funding gap
    
    mutate(tier1_funding_gap =
             ((tier1*final_adequacy_target)-final_resources) * tier1flag) |>
      
      # Tier 1 funding
      
      mutate(tier1_funding = tier1flag * (tier1_funding_gap*tier1_far)) |>
      mutate(tier1_perpupil =
               ifelse(total_ase > 0,
                      tier1_funding/total_ase,
                      0)) |>
      
      # Tier 2 funding gap
      
      mutate(tier2_funding_gap =
               ifelse(tier == 1 | tier ==2,
                      (((tier2*final_adequacy_target)-final_resources-tier1_funding_gap)*(1-local_cap_ratio_capped90)),
                      0)) |>
      
      # Tier 3 funding
      
      mutate(tier3_funding =
               ifelse(tier == 3, (t3funding/sum(tier3finaladequacy))*final_adequacy_target, # t3funding/sum(tier3finaladequacy) = tier 3 funding allocation ratio
                      0)) |>
      
      mutate(tier3_perpupil =
               ifelse(total_ase>0,
                      tier3_funding/total_ase,
                      0)) |>
      
      # Tier 4 funding
      
      
      mutate(tier4_funding =
               ifelse(tier == 4, (t4funding/sum(tier4finaladequacy))*final_adequacy_target, # t4funding/sum(tier4finaladequacy) = tier 4 funding allocation ratio
                      0)) |>
      mutate(tier4_perpupil =
               ifelse(total_ase>0,
                      tier4_funding/total_ase,
                      0)) |>
      
      
      # Tier 2 funding
      
      # Step 1
      
      mutate(tier2_funding_step1 =
               tier2_funding_gap * as.numeric(t2funding/sum(t2fg, na.rm = T))) |> # t2funding/sum(t2fg, na.rm = T = tier 2 funding allocation rate
      
      # Original Tier 2 Per Student
      
      mutate(tier2_perpupil_orig =
               ifelse(total_ase>0,
                      tier2_funding_step1/total_ase,
                      0)) |>
      # Step 2
      
      mutate(tier2_funding_step2 =
               ifelse(tier == 2 & tier2_perpupil_orig<as.numeric(max(tier3_perpupil)), # max(tier3_perpupil) Tier 3 Maximum Funding Per Student for Purposes of Caclulating Final Tier 2 Funding
                      as.numeric(max(tier3_perpupil))*total_ase,
                      tier2_funding_step1)) |>
      
      
      # Step 3
      
      mutate(tier2_funding_step3 =
               tier2_funding_step2 * 0.981) |> # FLAGGING THIS - This is a revision in the EBF calculation, unsure what it is ----- 
    
    # Final Tier 2 Per Student
    
    mutate(tier2_perpupil_final =
             ifelse(total_ase>0,
                    tier2_funding_step3/total_ase,
                    0)) |>
      
      # Calculating total state contribution --------------
    
    
    # Calculated new FY Funding
    
    mutate(new_fy_funding =
             tier1_funding +
             tier2_funding_step3 +
             tier3_funding +
             tier4_funding) |>
      
      # Calculated new FY Funding (per pupil)
      
      mutate(new_fy_funding_perpupil =
               ifelse(total_ase >0,
                      new_fy_funding/total_ase,
                      0)) |>
      
      # Total gross state FY contribution
      
      mutate(gross_fy_funding =
               new_fy_funding +
               base_funding_minimum)
    
  })
  
  # Use reactive dataframes to shape outputs ----
  
  # We will beable to use the ebfsim() as the reactive data frame for the
  # plot, map, table, and summary statistics
  
  # Plot ----
  
  output$plot1 <- renderPlotly({
    ggplotly(
      ggplot(ebfsim2(),
             aes(x=tier,y=ci_totalcost)) +
        geom_bar(stat = 'identity')
    )
    
    
  }) # close out plot -----
  
  # Map ----
  # Table ----
  # Summary statistics ----
  
}) # close out server ----
