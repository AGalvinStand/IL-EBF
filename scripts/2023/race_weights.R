options(scipen = 999)

library(tidyverse)
library(dplyr)
library(readr)
library(writexl)
library(readxl)

#Read in ISBE dataset
report_card <- read_excel("C:/Users/jpacas/Documents/GitHub/IL-EBF/data/raw/2022-Report-Card-Public-Data-Set.xlsx", sheet = "General")

table(report_card$Type)

#Prune unwanted variables
report_card_clean <- report_card[c(1, 2, 4, 6, 16, 17, 18, 19, 20, 21, 22, 23)]

#Keep only Districts
report_card_clean <- subset(report_card_clean, Type=="District")

#Truncate the last two digits for RCDTS to match DISTID
report_card_clean$RCDTS=substr(report_card_clean$RCDTS,1,13)

#Rename variables
new_names <- c("RCDTS",
               "school_type",
               "district_name",
               "county",
               "total_student_enroll",
               "white_per",
               "black_per",
               "latino_per",
               "asian_per",
               "pacific_per",
               "native_per",
               "multiple_per")

# manually replace column names
colnames(report_card_clean) <- new_names

#Create flag for majority-minority districts
report_card_clean$major_minor <- as.factor(ifelse(report_card_clean$white_per > 50, 0, 1))
report_card_clean <- transform(report_card_clean, nonwhite_per = 100 - white_per)

#######################
#Read in EBF datasets and merge with report card data
#######################

#Read in EBF_base_calc datasets
ebf_base_calc <- readRDS("C:/Users/jpacas/Documents/GitHub/IL-EBF/scripts/shiny/ebf_sim/data/ebf_base_calc.rds")

ebf_base_calc_race <- left_join(ebf_base_calc, report_card_clean,  
                                by = c("distid" = "RCDTS"), na_matches = "never")

#Read in EBF_base_calc with concentrated poverty datasets

ebf_base_calc_conpov <- readRDS("C:/Users/jpacas/Documents/GitHub/IL-EBF/scripts/shiny/ebf_sim/data/ebf_base_calc_conpov.rds")

ebf_base_calc_conpov_race <- left_join(ebf_base_calc_conpov, report_card_clean,  
                                       by = c("distid" = "RCDTS"), na_matches = "never")

#######################
#Create race weights
#######################


#25 for all, 75 for majority nonwhite

#EBF base calc
ebf_base_calc_race <- transform(ebf_base_calc_race,  addl_race_invest = ifelse(ebf_base_calc_race$major_minor==1, 
                                                          total_ase * 75, 
                                                          total_ase * 25)
                                )

ebf_base_calc_race <- transform(ebf_base_calc_race, 
                                final_adequacy_target_orig = final_adequacy_target,
                                final_percent_adequacy_orig = final_percent_adequacy)

ebf_base_calc_race <- transform(ebf_base_calc_race, 
                                final_adequacy_target = final_adequacy_target_orig + addl_race_invest,
                                final_percent_adequacy = final_resources / final_adequacy_target
                                )

write_rds(ebf_base_calc_race,"C:/Users/jpacas/Documents/GitHub/IL-EBF/scripts/shiny/ebf_sim/data/ebf_base_calc_race.rds")


#EBF base calc with concentrated poverty
ebf_base_calc_conpov_race <- transform(ebf_base_calc_conpov_race,  addl_race_invest = ifelse(ebf_base_calc_conpov_race$major_minor==1, 
                                                                               total_ase * 75, 
                                                                               total_ase * 25)
)

ebf_base_calc_conpov_race <- transform(ebf_base_calc_conpov_race, 
                                final_adequacy_target_orig = final_adequacy_target,
                                final_percent_adequacy_orig = final_percent_adequacy)

ebf_base_calc_conpov_race <- transform(ebf_base_calc_conpov_race, 
                                final_adequacy_target = final_adequacy_target_orig + addl_race_invest,
                                final_percent_adequacy = final_resources / final_adequacy_target
)

write_rds(ebf_base_calc_conpov_race,"C:/Users/jpacas/Documents/GitHub/IL-EBF/scripts/shiny/ebf_sim/data/ebf_base_calc_conpov_race.rds")

