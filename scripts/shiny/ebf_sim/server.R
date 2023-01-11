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
library(edbuildmapr)
library(leaflet)
library(sf)

options(shiny.trace = TRUE)

ebf_base_calc_conpov <- read_rds("data/ebf_base_calc_conpov.rds")
ebf_base_calc <- read_rds("data/ebf_base_calc.rds")
ebf_base_calc_race <- read_rds("data/ebf_base_calc_race.rds")
ebf_base_calc_conpov_race <- read_rds("data/ebf_base_calc_conpov_race.rds")

il_map_raw <- read_sf("data/il_map_raw.shp")
crosswalk <- read_rds("data/crosswalk.rds")

shinyServer(function(input, output, session) {
  
  goalyear1 <- reactive({
    paste("EBF as it is by the year ",input$years,sep="")
  })

   
   minimum_yearly_funding <- reactive({
     
     ebfsim <- get(input$df_test)
     
     (sum(ebfsim$final_adequacy_target) - sum(ebfsim$final_resources))/(input$years - as.numeric(format(Sys.time(), "%Y")))
   })
   
   output$myf <- reactive({
     dollar(minimum_yearly_funding(), na.rm = TRUE)
   })
   
   output$myf_diff <- reactive({
     myfd <- (sum(ebf_base_calc$final_adequacy_target) - sum(ebf_base_calc$final_resources))/(input$years - as.numeric(format(Sys.time(), "%Y")))
      paste("Compared to EBF as it is, this amounts to an additional ",dollar(minimum_yearly_funding() - myfd, na.rm = TRUE)," in minimum yearly funding increases.",sep="")
     })
   
   # output$fat_perpupil <- reactive({
   #   ebfsim <- get(input$df_test)
   #   dollar((sum(ebfsimfinal()$final_adequacy_target)/sum(ebfsimfinal()$total_ase))-(sum(ebf_base_calc$final_adequacy_target)/sum(ebf_base_calc$total_ase)))
   # })
   
   # output$poor_students <- reactive({
   #   total_students <- sum(ebfsim2()$total_ase)
   #   df <- ebfsim2() |>
   #     filter(tier == 1)
   #   percent(sum(df$total_ase,na.rm = T)/total_students, accuracy = 3)
   #   
   # })
   
   output$poor_students <- reactive({
     total_students <- 963114.2 # current number of students in tier 1
     df <- ebfsimfinal() |>
       filter(tier == 1)
     comma(sum(df$total_ase,na.rm = T) - total_students)
     
   })
   
   output$goal <- reactive({
     
     if (input$years == 2027) {
       return("You're on target to fully fund schools by 2027!")
     } else if ((input$years - 2027) == 1) {
       return(paste("You are ",(input$years - 2027)," year away from the original goal...",sep=""))
     } else if ((input$years - 2027) >= 10 & (input$years - 2027) < 20) {
       return(paste("You are getting pretty far off the mark, buddy. You are ",(input$years - 2027)," years away from the original goal.",sep=""))
     } else if ((input$years - 2027) >= 20 & (input$years - 2027) < 40) {
       return(paste("Ok, you are very, very far off the mark now. You are ",
                    (input$years - 2027),
                    " years away from the original goal. Sorry, maybe this wasn't clear. The goal was to fully-fund education for students in the current generation, not for your great great grandchildren.",sep=""))
     } else if ((input$years - 2027) >= 40) {
       return(paste("You are ",(input$years - 2027)," years away from the original goal. Congratulations, your clear disdain for public education will probably drive us all into a Mad Max-style post-apolocalyptic existence. Public education won't even exist anymore, so you'll like that. The main thing on people's minds will be mining scarce resources from Bullet Farm without dying or appeasing Immortan Joe for a chance to live out their brutal existence in the Citadel.",sep=""))
       
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
                        TRUE ~ 0))
   })
   
   # creating allocation rates for tier 2, 3, and 4 for next set of calculations
   
   t4ar <- reactive({
     as.numeric(t4funding())/sum(ebfsim2()$tier4finaladequacy)
   })
   t3ar <- reactive ({
     as.numeric(t3funding())/sum(ebfsim2()$tier3finaladequacy)
   })
   
   t2fg <- reactive({
     sum(ebfsim2()$tier2_funding_gap)
   })
   
   t2ar <- reactive({t2funding()/t2fg()})
   
   ebfsim3 <- reactive({
     
     ebfsim2() |>
     
     # Tier 3 funding
     
     mutate(tier3_funding =
              case_when(tier == 3 ~ final_adequacy_target*(t3ar()), # t3funding()/sum(tier3finaladequacy) = tier 3 funding allocation ratio
                        TRUE ~ 0)) |>

     mutate(tier3_perpupil =
              case_when(total_ase>0 ~ tier3_funding/total_ase,
                        TRUE ~ 0)) |>
     
     # Tier 4 funding
     
     
     mutate(tier4_funding =
              case_when(tier == 4 ~ final_adequacy_target*t4ar(), # t4funding()/sum(tier4finaladequacy) = tier 4 funding allocation ratio
                        TRUE ~ 0)) |>

     mutate(tier4_perpupil =
              case_when(total_ase>0 ~ tier4_funding/total_ase,
                        TRUE ~0)) |>
     
     
     # Tier 2 funding
     
     # Step 1
     
     mutate(tier2_funding_step1 =
              case_when(tier == 1 | tier == 2 ~ tier2_funding_gap * t2ar(),
                        TRUE ~ 0)) |> # t2funding()/sum(t2fg, na.rm = T = tier 2 funding allocation rate
     
     # Original Tier 2 Per Student
     
     mutate(tier2_perpupil_orig =
              case_when(total_ase>0 ~ tier2_funding_step1/total_ase,
                        TRUE ~ 0)) |>
     # Step 2
     
     mutate(tier2_funding_step2 =
              case_when(tier == 2 & tier2_perpupil_orig<as.numeric(max(tier3_perpupil)) ~ as.numeric(max(tier3_perpupil))*total_ase, # max(tier3_perpupil) Tier 3 Maximum Funding Per Student for Purposes of Caclulating Final Tier 2 Funding
                        TRUE ~ tier2_funding_step1))
     
   })
     
     # creating a reactive frame for the tier 2 revision (sum of tier 2 funding step 1 divided by step 2)
     
     step2revised <- reactive({
       sum(ebfsim3()$tier2_funding_step1)/sum(ebfsim3()$tier2_funding_step2)
     })
     
     ebfsimfinal <- reactive({
       
       ebfsim3() |>
                                                                  
     # Step 3
     
     mutate(tier2_funding_step3 =
              tier2_funding_step2 * step2revised()) |> # FLAGGING THIS - This is a revision in the EBF calculation, unsure what it is
   
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
     
     
     barchart <- reactive({
       ebfsimfinal() |>
       group_by(tier_text) |>
       summarise(tier = mean(tier),
                 new_fy_funding = sum(new_fy_funding),
                 total_ase = sum(total_ase)) |>
       mutate(new_funding_perpupil = new_fy_funding/total_ase)
     })
   
     
     output$fat_perpupil <- reactive({
       paste("Or an additional ",dollar(minimum_yearly_funding()/sum(ebfsimfinal()$total_ase)-(300000000/sum(ebf_base_calc$total_ase)))," per pupil.",sep="")
     })
     

 # Plot ----

     output$plot1 <- renderPlotly({
       ggplotly(
         ggplot(barchart(),
                aes(x=as.factor(tier), 
                    y=new_funding_perpupil,
                    text = paste0("This amounts to <b>", dollar(new_funding_perpupil),"</b> per student in tier ",as.character(tier)))) +
           geom_bar(stat = "identity",
                    position = "dodge") +
           xlab("Tier") +
           ylab("New allocation appropriation (per pupil)") +
           scale_y_continuous(labels = dollar_format(), limits = c(0,1200)) +
           theme_bw(),
         tooltip = "text"
       )
       
     }) # close out plot -----

 # Map ----
     
     crosswalkmerge <- reactive ({
       merge(ebfsimfinal(), crosswalk, by.x = "distid", by.y = "District ID", all = FALSE)
     })

      map_data <- reactive({ ## joining the shapefile data with the reactive data we've created in the app already
        merge(il_map_raw, crosswalkmerge(), by.x = "geoid", by.y = "ncesid")
     
      })
      
      map_uni <- reactive({
        
        map_data() |>
        dplyr::filter(orgtype == "Unit")
        
      })
      
      map_elem <- reactive({
        map_data() |>
          dplyr::filter(orgtype == "Elementary" )

      })
      
      map_sec <- reactive({
        map_data() |>
          dplyr::filter(orgtype == "High School")
        
      })
      

     
     output$map <- renderLeaflet({  ## rendering the map
       
       # state_aid_pal <- colorBin(
       #   palette = c( "firebrick","#DD513AFF", "#FCA50AFF",
       #                "grey84",
       #                "#AADC32FF","#5DC863FF", "forestgreen"),
       #   bins = c(-10000, -1000, -250, -50, 50, 250, 1000, 10000),
       #   domain = map_data()$state_total_pp)
       pal <- colorQuantile(palette = "YlOrRd",
                            domain = map_data()$new_fy_funding_perpupil,
                            n = 4)
       
       leaflet() %>% # actually creating the map by applying all the reactive expressions we previously defined
         # addProviderTiles("CartoDB.Positron") |>
         addPolygons(data = map_uni(),
                     fillOpacity = 0.5, # make the layers 50% transparent so you can see the background map below
                     weight = 0.5, # line thickness
                     highlightOptions = highlightOptions(color = "white", weight = 1,
                                                         bringToFront = TRUE),
                     popup = paste("<strong>", map_uni()$name, "</strong>", "<br>",
                                   paste0("Tier: ", map_uni()$tier_text),
                                   "<br>",
                                   paste0("New per pupil funding: ", dollar(map_uni()$new_fy_funding_perpupil)),
                                   "<br>",
                                   paste0("Percent nonwhite: ", percent(map_uni()$pctnw,accuracy = 1)),
                                   "<br>",
                                   paste0("Percent student poverty: ", percent(map_uni()$stpovrt,accuracy = 1))),
                      fillColor = ~pal(map_data()$new_fy_funding_perpupil),
                     group = "Unified districts") |>
         addPolygons(data = map_elem(),
                     fillOpacity = 0.5, # make the layers 50% transparent so you can see the background map below
                     weight = 0.5, # line thickness
                     group = "Elementary districts",
                     highlightOptions = highlightOptions(color = "white", weight = 1,
                                                         bringToFront = TRUE),
                     popup = paste("<strong>", map_elem()$name, "</strong>", "<br>",
                                   paste0("Tier: ", map_elem()$tier_text),
                                   "<br>",
                                   paste0("New per pupil funding: ", dollar(map_elem()$new_fy_funding_perpupil)),
                                   "<br>",
                                   paste0("Percent nonwhite: ", percent(map_elem()$pctnw,accuracy = 1)),
                                   "<br>",
                                   paste0("Percent student poverty: ", percent(map_elem()$stpovrt,accuracy = 1))),
                     fillColor = ~pal(map_data()$new_fy_funding_perpupil)) |>
         addPolygons(data = map_sec(),
                     fillOpacity = 0.5, # make the layers 50% transparent so you can see the background map below
                     weight = 0.5, # line thickness
                     group = "High school districts",
                     highlightOptions = highlightOptions(color = "white", weight = 1,
                                                         bringToFront = TRUE),
                     popup = paste("<strong>", map_sec()$name, "</strong>", "<br>",
                                   paste0("Tier: ", map_sec()$tier_text),
                                   "<br>",
                                   paste0("New per pupil funding: ", dollar(map_sec()$new_fy_funding_perpupil)),
                                   "<br>",
                                   paste0("Percent nonwhite: ", percent(map_sec()$pctnw,accuracy = 1)),
                                   "<br>",
                                   paste0("Percent student poverty: ", percent(map_sec()$stpovrt,accuracy = 1))),
                     fillColor = ~pal(map_data()$new_fy_funding_perpupil)) |>
         addLegend(data = map_data(),
                   position = "bottomright",
                    values = ~new_fy_funding_perpupil,
                   pal = pal,
                    title = paste("New EBF funding per pupil","<br>","</strong>","Quartiles")) |>
          addLayersControl(overlayGroups = c("Unified districts", 
                                             "High school districts",
                                             "Elementary districts"),
                           options = layersControlOptions(collapsed=F))

       
       # %>%
         # addLegend(position = "bottomright",
         #           pal = state_aid_pal,
         #           values = ~state_total_pp,
         #           title = "Change in PP $")
     })
     
     
     output$tbl <- renderDataTable({
       
       # cleantable <- ebfsimfinal()[,c(`distid`)]
       # # ,2,14:17,22:24,45:47)]
       # #  
       # colnames(cleantable) <- c("District ID")
       #                           # "District name",
       #                           # "Final resources",
       #                           # "District type",
       #                           # "Total ASE",
       #                           # "Final resources",
       #                           # 
       #                           # "Percent to adqueacy",
       #                           # "District type",
       #                           # "Total ASE",
       #                           # "Final adequacy target",
       #                           # "Final adequacy target (per pupil)",
       #                           # "Tier",
       #                           # "New funding",
       #                           # "New funding (per pupil)",
       #                           # "Gross funding")
       
       datatable(ebfsimfinal(),
                 rownames = FALSE,
                 options = list(paging = FALSE, 
                                scrollY = "700px", scrollX = TRUE,
                                scrollCollapse = TRUE))
       # |> 
         # formatCurrency(c("New State Funding Total",
         #                  "Current State Funding Total",
         #                  "State Total Diff",
         #                  "New State Per Pupil",
         #                  "Current State Per Pupil",
         #                  "Per Pupil Diff"),
         #                digits = 0) |> 
         # formatPercentage("FRPL Pct", digits = 0) |> 
         # formatRound(c("Enrollment", "FRPL Student Count"), digits = 0) |> 
         # # make negative numbers red
         # formatStyle(names(dist_summary()), color = JS("value < 0 ? 'red' : 'black'")) 
       
     })
 # Download table
     
     # this function will allow you to download a .csv of your data
     output$download_data <- downloadHandler(
       
       filename = function() {
         # this names the csv file with today's date
         paste('output-', Sys.Date(), '.csv', sep='') 
       },
       content = function(file) {
         write_csv(ebfsimfinal(), file)
       }
       
     ) # close downloadHandler

}) # close out server ----
