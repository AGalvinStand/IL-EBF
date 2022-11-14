options(scipen = 999)

library(tidyverse)
library(dplyr)
library(readr)
library(fuzzyjoin)
library(writexl)


report_card <- read_excel("C:/Users/jpacas/Documents/GitHub/IL-EBF/data/raw/2022-Report-Card-Public-Data-Set.xlsx", sheet = "General")

table(report_card$Type)
report_card_clean <- report_card[c(1, 2, 4, 6, 16, 17, 18, 19, 20, 21, 22, 23)]

report_card_clean <- subset(report_card_clean, Type=="District")
report_card_clean$RCDTS <- as.numeric(report_card_clean$RCDTS)
report_card_clean <- transform(report_card_clean, RCDTS = RCDTS/100)

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

report_card_clean$major_minor <- as.factor(ifelse(report_card_clean$white_per > 50, 0, 1))
report_card_clean <- transform(report_card_clean, nonwhite_per = 100 - white_per)

df1 <- readRDS("C:/Users/jpacas/Documents/GitHub/IL-EBF/scripts/shiny/ebf_sim/data/ebf_base_calc.rds")
df1$distid <- as.numeric(df1$distid)

ebf_base_calc_race <- left_join(df1, report_card_clean,  
                                by = c("distid" = "RCDTS"), na_matches = "never")


write_rds(ebf_base_calc_race,"C:/Users/jpacas/Documents/GitHub/IL-EBF/scripts/shiny/ebf_sim/data/ebf_base_calc_race.rds")



missing_data <- subset(ebf_base_calc_race, is.na(ebf_base_calc_race$total_student_enroll))
missing_data <- missing_data[c(1, 2)]

write_xlsx(missing_data,"C:/Users/jpacas/Documents/GitHub/IL-EBF/data/raw/missing_race_data.xlsx")





