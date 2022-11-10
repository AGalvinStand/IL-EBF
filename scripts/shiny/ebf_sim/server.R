# server.r

# EBF simulator

# Load -------
library(shiny)
library(shinythemes)
# library(shinydashboard)
# library(shinyBS)
# library(htmltools)
library(DT)
# library(leaflet)
require(scales)
library(plotly)
library(tidyverse)
library(base)

options(shiny.trace = TRUE)

library(shiny)

ebf_base_calc_conpov <- read_rds("data/ebf_base_calc_conpov.rds")
ebf_base_calc <- read_rds("data/ebf_base_calc.rds")

shinyServer(function(input, output, session) {

   
   minimum_yearly_funding <- reactive({
     
     ebfsim <- get(input$df_test)
     
     (sum(ebfsim$final_adequacy_target) - sum(ebfsim$final_resources))/(input$years - as.numeric(format(Sys.time(), "%Y")))
   })
   
   output$myf <- reactive({
     dollar(minimum_yearly_funding(), na.rm = TRUE)
   })
   
   output$myf_diff <- reactive({
     myfd <- (sum(ebf_base_calc$final_adequacy_target) - sum(ebf_base_calc$final_resources))/(input$years - as.numeric(format(Sys.time(), "%Y")))
       dollar(minimum_yearly_funding() - myfd, na.rm = TRUE)
     })
   
   
   output$goal <- reactive({
     
     if (input$years == 2027) {
       return("Yes, you're on target to fully fund schools by 2027!")
     } else if ((input$years - 2027) == 1) {
       return(paste("No. You are ",(input$years - 2027)," year away from the original goal...",sep=""))
     } else if ((input$years - 2027) > 10) {
       return(paste("You are getting pretty far off the mark. You are ",(input$years - 2027)," years away from the original goal...You are a wretched human being",sep=""))
     } else if ((input$years - 2027) > 20) {
       return(paste("ok, you are very far off. You are ",
                    (input$years - 2027),
                    " years away from the original goal. Sorry, maybe this wasn't clear. The goal was to fully-fund education for students today, not for your great great grandchildren.",sep=""))
       
     } else {
       return(paste("No. You are ",(input$years - 2027)," years away from the original goal...",sep=""))
     }
    })
   
   # tier 1 new appropriation allocation (50% of NAA, statutorily set)
   
   t1funding <- reactive({
     minimum_yearly_funding()*.5
   })
   
   # tier 1 funding gap, which is equal to the  (30% of funding gap)
   
   t1fg <- reactive({
     t1funding()/.3
   })
   
   # tier 2 new appropriation allocation (49% of NAA, statutorily set)
   
   t2funding <- reactive({
     minimum_yearly_funding()*.49
   })
   
   # tier 3 new appropriation allocation (0.9% of NAA, statutorily set)
   
   t3funding <- reactive({
     minimum_yearly_funding()*.009
   })
   
   # tier 4 new appropriation allocation (0.1% of NAA, statutorily set)
   
   t4funding <- reactive({
     minimum_yearly_funding()*.001
   })
   
   t1tr <- reactive({
     
     gap <- function(y) {
       ebfsim <- get(input$df_test)
       ebfsim$t1cutoff <- case_when(ebfsim$final_percent_adequacy < y ~ ((y*ebfsim$final_adequacy_target)-ebfsim$final_resources),
                                    FALSE ~ 0)
       return(sum(ebfsim$t1cutoff, na.rm = TRUE))
     }
     
     # This plugs in percentages from 0 to 1 until it finds the optimal cut off,
     # which is the funding gap (see below for equation) minus x (the funding gap)
     # so that the optimal percent is when the gap minum the gap = 0
     
     targetratio <- function(x, lower, upper) {
       optimize(function(y) abs(gap(y) - x), lower=lower, upper=upper, tol = 0.00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001)
     }
     
     tr_table <- targetratio(t1fg(), # set the first number as the total tier 1 funding gap = (new appropriation allocation*.5)/.3, in other words the new tier 1 funding (half of the new allocation amount, that's statutory) divided by the tier 1 allocation rate (30% which is statutory)
                             0.0000000000000000000000000000000000000000000000000000000000000, # the low point to be searched (0% adequacy level cut off)
                             1) # the high point to be searched (100% adequacy level cut off)
     
     return(tr_table$minimum)
     
   })

   # create reactive dataframe for year input ----------

   ebfsim2 <- reactive({

   # Pre-Stage 3: Determining Tier

   # Tier 1 target ratio threshold function

   # This will return a sum of the optimal cut off percent.
   # It does so by summing the funding gap model -
   # sum of (tier 1 target ratio * final adequacy level)-final resources for each
   # district below the cut off percent selected.
     ebfsim <- get(input$df_test)

   ebfsim |>
     
     # use the target ratio to assign tiers and tier2 funding gap
     
     
       mutate(tiers = case_when(final_percent_adequacy < as.numeric(t1tr()) ~ 1,
                                final_percent_adequacy > as.numeric(t1tr()) & final_percent_adequacy < .9 ~ 2,
                                final_percent_adequacy > .9 & final_percent_adequacy < 1 ~ 3,
                                final_percent_adequacy > 1 ~ 4,
                                FALSE ~ 0)) |>
       mutate(t1fundinggap = case_when(tiers == 1 ~ (t1tr()*final_adequacy_target)-final_resources,
                                       TRUE~0)) |>
       mutate(t1funding = case_when(tiers == 1 ~ t1fundinggap * .3,
                                    TRUE~0)) |>
       
       # .9 is the tier 2 ratio
       
       mutate(t2fg = case_when(tiers < 3 ~ ((.9*final_adequacy_target)-final_resources-t1funding)-(1- local_cap_ratio_capped90),
                               TRUE~0)) |>
  
     
     # Adequacy funding gap 
     
     mutate(adequacy_funding_level =
              final_resources / final_adequacy_target) |> 
     
     # Adequacy Funding Level
     
     mutate(adequacy_funding_level =
              final_resources / final_adequacy_target) |> 
     
     # Assign tiers based on Adequacy Funding Level
     
     mutate(tier =
              case_when(adequacy_funding_level < as.numeric(t1tr()) ~ 1,
                        adequacy_funding_level < .9 & adequacy_funding_level >= as.numeric(t1tr()) ~ 2,
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
              ((as.numeric(t1tr())*final_adequacy_target)-final_resources) * tier1flag) |>
     
     # Tier 1 funding
     
     mutate(tier1_funding = tier1flag * (tier1_funding_gap*.3)) |> # 30% allocation rate is set by legislation (The funding allocation ratio)
     mutate(tier1_perpupil =
              ifelse(total_ase > 0,
                     tier1_funding/total_ase,
                     0)) |>
     
     # Tier 2 funding gap
     
     mutate(tier2_funding_gap =
              case_when(tier == 1 | tier ==2 ~ ((.9*final_adequacy_target)-final_resources-tier1_funding_gap)*(1-local_cap_ratio_capped90),
                        TRUE ~ 0)) |>
     
     # Tier 3 funding
     
     mutate(tier3_funding =
              case_when(tier == 3 ~ (t3funding()/sum(tier3finaladequacy))*final_adequacy_target, # t3funding()/sum(tier3finaladequacy) = tier 3 funding allocation ratio
                        TRUE ~ 0)) |>

     mutate(tier3_perpupil =
              case_when(total_ase>0 ~ tier3_funding/total_ase,
                        TRUE ~ 0)) |>
     
     # Tier 4 funding
     
     
     mutate(tier4_funding =
              case_when(tier == 4 ~ (t4funding()/sum(tier4finaladequacy))*final_adequacy_target, # t4funding()/sum(tier4finaladequacy) = tier 4 funding allocation ratio
                        TRUE ~ 0)) |>

     mutate(tier4_perpupil =
              case_when(total_ase>0 ~ tier4_funding/total_ase,
                        TRUE ~0)) |>
     
     
     # Tier 2 funding
     
     # Step 1
     
     mutate(tier2_funding_step1 =
              case_when(tier == 1 | tier == 2 ~ tier2_funding_gap * as.numeric(t2funding()/sum(t2fg, na.rm = T)),
                        TRUE ~ 0)) |> # t2funding()/sum(t2fg, na.rm = T = tier 2 funding allocation rate
     
     # Original Tier 2 Per Student
     
     mutate(tier2_perpupil_orig =
              case_when(total_ase>0 ~ tier2_funding_step1/total_ase,
                        TRUE ~ 0)) |>
     # Step 2
     
     mutate(tier2_funding_step2 =
              case_when(tier == 2 & tier2_perpupil_orig<as.numeric(max(tier3_perpupil)) ~ as.numeric(max(tier3_perpupil))*total_ase, # max(tier3_perpupil) Tier 3 Maximum Funding Per Student for Purposes of Caclulating Final Tier 2 Funding
                        TRUE ~ tier2_funding_step1)) |>
                                                                  
     # Step 3
     
     mutate(tier2_funding_step3 =
              tier2_funding_step2 * 0.981) |> # FLAGGING THIS - This is a revision in the EBF calculation, unsure what it is
   
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
     

   })
   
   

 # Use reactive dataframes to shape outputs ----

   # We will beable to use the ebfsim() as the reactive data frame for the
   # plot, map, table, and summary statistics

 # Plot ----

     output$plot1 <- renderPlotly({
       ggplotly(
         ggplot(ebfsim2(),
                aes(x=tier, y=new_fy_funding_perpupil)) +
           geom_col() +
           scale_y_continuous(labels = dollar_format(), limits = c(0,650000000)) +
           theme_bw()
       )


     }) # close out plot -----

 # Map ----
 # Table ----
 # Summary statistics ----

}) # close out server ----
