# PURPOSE ---------

#   This script will calculate additional investments in the EBF formula
#   with the concentrated poverty weight.

# -------------

# PREPARED BY ------

# Ayesha Safdar

# 08-18-22

#----------

# load ---------

options(scipen = 999)

library(tidyverse)
library(readxl)

# AVERAGE SALARY VARIABLES --------

il_fy22_cvs_avgsalary_raw <- read_excel("data/raw/FY22-EBF-Full-Calc-Revised.xlsx", sheet = 3,
                                        skip = 7,n_max = 4)

# fix column names
il_fy22_cvs_avgsalary_raw <- il_fy22_cvs_avgsalary_raw |>
  # convert colnames to lowercase
  rename_with(tolower) 

# look at column names
names(il_fy22_cvs_avgsalary_raw)

# new column names

# naming convention - delete# is the column number used to delete further
#                     down in the script

new_names <- c("grade",
               "guidance_counselor",
               "school_psychologist",
               "school_nurse",
               "assistant_principal",
               "core_teacher",
               "social_worker",
               "librarian_mediaspecialist",
               "principal")

# manually replace column names
colnames(il_fy22_cvs_avgsalary_raw) <- new_names

# look at column names now
names(il_fy22_cvs_avgsalary_raw)

# rename raw to clean

il_fy22_cvs_avgsalary_clean <- il_fy22_cvs_avgsalary_raw

# ADDITIONAL INVESTMENTS - LOW INCOME  --------

il_fy22_cvs_additionalinvestment_li_raw <- read_excel("data/raw/FY22-EBF-Full-Calc-Revised.xlsx", sheet = 3,
                                                      skip = 56,n_max = 4)

# fix column names
il_fy22_cvs_additionalinvestment_li_raw <- il_fy22_cvs_additionalinvestment_li_raw |>
  # convert colnames to lowercase
  rename_with(tolower) 

# look at column names
names(il_fy22_cvs_additionalinvestment_li_raw)

# new column names

# naming convention - delete# is the column number used to delete further
#                     down in the script

new_names <- c("grade",
               "intervention_teacher",
               "pupil_support",
               "extended_day_teacher",
               "summerschool_teacher")

# manually replace column names
colnames(il_fy22_cvs_additionalinvestment_li_raw) <- new_names

# look at column names now
names(il_fy22_cvs_additionalinvestment_li_raw)

# cleaned data frame

il_fy22_cvs_additionalinvestment_li_clean <- il_fy22_cvs_additionalinvestment_li_raw


# ADDITIONAL INVESTMENTS - ENGLISH LEARNER  --------

il_fy22_cvs_additionalinvestment_el_raw <- read_excel("data/raw/FY22-EBF-Full-Calc-Revised.xlsx", sheet = 3,
                                                      skip = 63,n_max = 4)

# fix column names
il_fy22_cvs_additionalinvestment_el_raw <- il_fy22_cvs_additionalinvestment_el_raw |>
  # convert colnames to lowercase
  rename_with(tolower) 

# look at column names
names(il_fy22_cvs_additionalinvestment_el_raw)

# new column names

# naming convention - delete# is the column number used to delete further
#                     down in the script

new_names <- c("grade",
               "intervention_teacher",
               "pupil_support",
               "extended_day_teacher",
               "summerschool_teacher",
               "english_learner_core_teacher")

# manually replace column names
colnames(il_fy22_cvs_additionalinvestment_el_raw) <- new_names

# look at column names now
names(il_fy22_cvs_additionalinvestment_el_raw)

# cleaned data frame

il_fy22_cvs_additionalinvestment_el_clean <- il_fy22_cvs_additionalinvestment_el_raw

# ADDITIONAL INVESTMENTS - SPECIAL EDUCATION  --------

il_fy22_cvs_additionalinvestment_sped_raw <- read_excel("data/raw/FY22-EBF-Full-Calc-Revised.xlsx", sheet = 3,
                                                        skip = 70,n_max = 4)

# fix column names
il_fy22_cvs_additionalinvestment_sped_raw <- il_fy22_cvs_additionalinvestment_sped_raw |>
  # convert colnames to lowercase
  rename_with(tolower) 

# look at column names
names(il_fy22_cvs_additionalinvestment_sped_raw)

# new column names

# naming convention - delete# is the column number used to delete further
#                     down in the script

new_names <- c("grade",
               "sped_core_teacher",
               "instructional_assistant",
               "pyschologist")

# manually replace column names
colnames(il_fy22_cvs_additionalinvestment_sped_raw) <- new_names

# look at column names now
names(il_fy22_cvs_additionalinvestment_sped_raw)

# cleaned data frame

il_fy22_cvs_additionalinvestment_sped_clean <- il_fy22_cvs_additionalinvestment_sped_raw

# clean district id data --------------

# load il ebf raw data -  skip to row four. Referencing the FY22-EBF..xlsx
#                         to clean the column names

il_fy22_dist_join <- read_excel("data/raw/FY22-EBF-Full-Calc-Revised.xlsx", sheet = 2,
                                skip = 10)



# fix column names
# il_fy22_dist_join |> il_fy22_dist_join
# convert colnames to lowercase
# rename_with(tolower) 

# look at column names
names(il_fy22_dist_join)

# create vector of new column names - include blank columns,
# rename these to delete1....N.

new_names <- c("distid",
               "distname",
               "county",
               "orgtype")

# manually replace column names
colnames(il_fy22_dist_join) <- new_names

# look at column names now
names(il_fy22_dist_join)

# select only columns with data

# delete duplicate columns (at the end after "total") and
# delete the empty columns using command below. Tidyverse's
# mutate command (i.e. keep = c(selected columns) does not
# work when there are duplicate columns (the 3 columns at the
# end, 37-40).

il_fy22_dist_join <- il_fy22_dist_join[,-c(5:61)]


# clean enrollment all data--------------

# load il ebf raw data -  skip to row four. Referencing the FY22-EBF..xlsx
#                         to clean the column names

il_fy22_enroll_all_raw <- read_excel("data/raw/FY22-EBF-Full-Calc-Revised.xlsx", sheet = 9, skip = 4) 

# fix column names
il_fy22_enroll_all_raw |>
  # convert colnames to lowercase
  rename_with(tolower) 

# look at column names
names(il_fy22_enroll_all_raw)

# create vector of new column names - include blank columns,
# rename these to delete1....N.
new_names <- c("distid",
               "distname",
               "county",
               "orgtype",
               "greaterof",
               "tot_ase",
               "delete",
               "enroll_k_3",
               "enroll_4_12",
               "delete2",
               "enroll_4_8",
               "enroll_9_12",
               "delete3",
               "enroll_dist_elem", #PK-8
               "enroll_dist_hs",   #9-12
               "enroll_dist_reg",  #Unit Labs Regional PK-12
               "delete4",
               "enroll_school_elem_pk_5",
               "enroll_school_elem_k_5",
               "enroll_school_mid_6_8",
               "enroll_school_hs_9_12",
               "delete5",
               "enroll_sped_pk",
               "enroll_k_all",     # includes 1/2 counted as .5
               "enroll_1",
               "enroll_2",
               "enroll_3",
               "enroll_4",
               "enroll_5",
               "enroll_6",
               "enroll_7",
               "enroll_8",
               "enroll_9",
               "enroll_10",
               "enroll_11",
               "enroll_12",
               "total") # total = tot_ase

# manually replace column names
colnames(il_fy22_enroll_all_raw) <- new_names

# look at column names now
names(il_fy22_enroll_all_raw)

# look at district names - they are imported as characters!
glimpse(il_fy22_enroll_all_raw$distid)

# select only columns with data

# delete duplicate columns (at the end after "total") and
# delete the empty columns using command below. Tidyverse's
# mutate command (i.e. keep = c(selected columns) does not
# work when there are duplicate columns (the 3 columns at the
# end, 37-40).

il_fy22_enroll_all_clean <- il_fy22_enroll_all_raw[,-c(7,10,13,17,22,37:40)]

il_fy22_enroll_all_clean <- il_fy22_enroll_all_clean[c('distid','distname','tot_ase')]

# clean low income enrollment --------------

# load il ebf raw data -  skip to row five. Referencing the FY22-EBF..xlsx
#                         to clean the column names

il_fy22_enroll_li_raw <- read_excel("data/raw/FY22-EBF-Full-Calc-Revised.xlsx", sheet = 10,
                                    skip = 5) 

# fix column names
il_fy22_enroll_li_raw <- il_fy22_enroll_li_raw |>
  # convert colnames to lowercase
  rename_with(tolower) 

# look at column names
names(il_fy22_enroll_li_raw)

# create vector of new column names - include blank columns,
# rename these to delete1....N.

# naming convention: li = low income
# delete has column number after for deleting column

new_names <- c("distid",
               "distname",
               "dhs_2018",
               "dhs_2019",
               "dhs_2020",
               "dhs_3yravg",
               "dhs_final", # Final count, greater of the 3 year avg or current year
               "delete8",
               "tot_ase",
               "li_per",
               "enroll_k_3",
               "enroll_k_3_li",
               "enroll_k_3_noli",
               "delete14",
               "enroll_4_8",
               "enroll_4_8_li",
               "enroll_4_8_noli",
               "delete18",
               "enroll_9_12",
               "enroll_9_12_li",
               "enroll_9_12_noli")

# manually replace column names
colnames(il_fy22_enroll_li_raw) <- new_names

# look at column names now
names(il_fy22_enroll_li_raw)

# look at district names - they are imported as characters!
glimpse(il_fy22_enroll_li_raw$distid)

# select only columns with data

# delete duplicate columns (at the end after "total") and
# delete the empty columns using command below. Tidyverse's
# mutate command (i.e. keep = c(selected columns) does not
# work when there are duplicate columns (the 3 columns at the
# end, 37-40).

il_fy22_enroll_li_clean <- il_fy22_enroll_li_raw[,-c(8,14,18)]

il_fy22_enroll_li_clean <- il_fy22_enroll_li_clean[c('distid','dhs_final')]

# clean el enrollment data--------------

# load il ebf raw data -  skip to row four. Referencing the FY22-EBF..xlsx
#                         to clean the column names

il_fy22_enroll_el_raw <- read_excel("data/raw/FY22-EBF-Full-Calc-Revised.xlsx", sheet = 13,
                                    skip = 4)

# fix column names
il_fy22_enroll_el_raw <- il_fy22_enroll_el_raw |>
  # convert colnames to lowercase
  rename_with(tolower) 

# look at column names
names(il_fy22_enroll_el_raw)

# new column names

# naming convention - delete# is the column number used to delete further
#                     down in the script

new_names <- c("distid",
               "distname",  # Confirm that RCDT is district id
               "el_2019",
               "el_2020",
               "el_2021",
               "delete6",
               "el_3yravg",
               "delete8",
               "el_final", # Final el count (greater of current year or 3 year average)
               "selected")

# manually replace column names
colnames(il_fy22_enroll_el_raw) <- new_names

# look at column names now
names(il_fy22_enroll_el_raw)

# look at district names - they are imported as characters!
glimpse(il_fy22_enroll_li_raw$distid)

# delete unwanted columns

il_fy22_enroll_el_clean <- il_fy22_enroll_el_raw[,-c(6,8)]

il_fy22_enroll_el_clean <- il_fy22_enroll_el_clean[c('distid','el_final')]

# merging enrollment data

temp_df <- merge(il_fy22_enroll_all_clean, il_fy22_enroll_li_clean, by = 'distid')

il_fy22_additional_investments <- merge(temp_df, il_fy22_enroll_el_clean, by = 'distid')

# CALCULATE LOW INCOME INVESTMENTS 

# Calculate number of low-income intervention teachers and cost of low-income intervention teachers per district 
# create li_intervention,

# Add concentrated poverty weight (once a district hits the 60% threashold decrease students to staff and teachers)

# Teachers and staff to student ratio in concentrated poverty districts

cp_per_pupil_support <- 110
cp_intervention_teacher <- 110
cp_extended_day_teacher <- 80
cp_summer_school_teacher <- 80

per_pupil_support <- as.numeric(il_fy22_cvs_additionalinvestment_li_clean$pupil_support[1])
intervention_teacher <- as.numeric(il_fy22_cvs_additionalinvestment_li_clean$intervention_teacher[1])
extended_day_teacher <- as.numeric(il_fy22_cvs_additionalinvestment_li_clean$extended_day_teacher[1])
summer_school_teacher <- as.numeric(il_fy22_cvs_additionalinvestment_li_clean$summerschool_teacher[1])

# Low income percent (used for concentrated poverty cut off)

il_fy22_additional_investments$li_percent <- il_fy22_additional_investments$dhs_final/il_fy22_additional_investments$tot_ase

# li_intervention

il_fy22_additional_investments$li_intervention <- il_fy22_additional_investments$dhs_final / intervention_teacher

il_fy22_additional_investments <- il_fy22_additional_investments |>
  mutate(cp_intervention = 
           ifelse(li_percent < .6,dhs_final/intervention_teacher,dhs_final/cp_intervention_teacher))

# li_intervention cost with concentrated poverty weight

il_fy22_additional_investments$cp_intervention_cost <- il_fy22_additional_investments$cp_intervention * 68735.0

# create li_intervention_cost

il_fy22_additional_investments$li_intervention_cost <- il_fy22_additional_investments$li_intervention * 68735.0

# Difference between old calculation and new calculation

cp_intervention_teacher_diff <- as.numeric(sum(il_fy22_additional_investments$cp_intervention_cost)-sum(il_fy22_additional_investments$li_intervention))

# Calculate number of low-income per pupil supports and cost of low-income per pupil supports per district 
# create li_per_pupil

il_fy22_additional_investments$li_per_pupil <- il_fy22_additional_investments$dhs_final / per_pupil_support

# create li_per_pupil_cost

il_fy22_additional_investments$li_per_pupil_cost <- il_fy22_additional_investments$li_per_pupil * 68735.0

# Concentrated poverty intervention per pupil support -----

il_fy22_additional_investments <- il_fy22_additional_investments |>
  mutate(cp_per_pupil = 
           ifelse(li_percent < .6,dhs_final/per_pupil_support,dhs_final/cp_per_pupil_support))

il_fy22_additional_investments$cp_per_pupil_support_cost <- il_fy22_additional_investments$cp_per_pupil * 68735.0

# Difference between old calculation and new calculation

cp_support_teacher_diff <- as.numeric(sum(il_fy22_additional_investments$cp_per_pupil_support_cost)-sum(il_fy22_additional_investments$li_per_pupil_cost))

# Calculate number of low-income extended day teachers and cost of low-income extended day teachers per district 
# create li_extended

il_fy22_additional_investments$li_extended <- il_fy22_additional_investments$dhs_final / extended_day_teacher

# create li_extended_cost

il_fy22_additional_investments$li_extended_cost <- il_fy22_additional_investments$li_extended * 68735.0

# Concentrated poverty intervention extended day teacher -----

il_fy22_additional_investments <- il_fy22_additional_investments |>
  mutate(cp_extended = 
           ifelse(li_percent < .6,dhs_final/extended_day_teacher,dhs_final/cp_extended_day_teacher))

il_fy22_additional_investments$cp_extended_day_teacher_cost <- il_fy22_additional_investments$cp_extended * 68735.0

# Difference between old calculation and new calculation

cp_extended_day_teacher_diff <- as.numeric(sum(il_fy22_additional_investments$cp_extended_day_teacher_cost)-sum(il_fy22_additional_investments$li_extended_cost))

# Calculate number of low-income summer school teachers and cost of low-income summer school teachers per district 
# create li_summer

il_fy22_additional_investments$li_summer <- il_fy22_additional_investments$dhs_final / summer_school_teacher

# create li_summer_cost

il_fy22_additional_investments$li_summer_cost <- il_fy22_additional_investments$li_summer * 68735.0

# Concentrated poverty intervention summer school teacher -----

il_fy22_additional_investments <- il_fy22_additional_investments |>
  mutate(cp_summer_school = 
           ifelse(li_percent < .6,dhs_final/summer_school_teacher,dhs_final/cp_summer_school_teacher))

il_fy22_additional_investments$cp_summer_school_teacher_cost <- il_fy22_additional_investments$cp_summer_school * 68735.0

# Difference between old calculation and new calculation

cp_summer_school_diff <- as.numeric(sum(il_fy22_additional_investments$cp_summer_school_teacher_cost)-sum(il_fy22_additional_investments$li_summer_cost))

# Difference for all

cp_diff = cp_summer_school_diff+cp_extended_day_teacher_diff+cp_intervention_teacher_diff+cp_support_teacher_diff

#CALCULATE ENGLISH LEARNER INVESTMENTS 

# Calculate number of english learner intervention teachers and cost of english learner intervention teachers per district 
# create el_intervention

il_fy22_additional_investments$el_intervention <- il_fy22_additional_investments$el_final / il_fy22_cvs_additionalinvestment_el_clean$intervention_teacher[1]

# create el_intervention_cost

il_fy22_additional_investments$el_intervention_cost <- il_fy22_additional_investments$el_intervention * 68735.0

# Calculate number of english learner per pupil supports and cost of english learner per pupil supports per district 
# create el_per_pupil

il_fy22_additional_investments$el_per_pupil <- il_fy22_additional_investments$el_final / il_fy22_cvs_additionalinvestment_el_clean$pupil_support[1]

# create el_per_pupil_cost

il_fy22_additional_investments$el_per_pupil_cost <- il_fy22_additional_investments$el_per_pupil * 68735.0

# Calculate number of english learner extended day teachers and cost of english learner extended day teachers per district 
# create el_extended

il_fy22_additional_investments$el_extended <- il_fy22_additional_investments$el_final / il_fy22_cvs_additionalinvestment_el_clean$extended_day_teacher[1]

# create el_extended_cost

il_fy22_additional_investments$el_extended_cost <- il_fy22_additional_investments$el_extended * 68735.0

# Calculate number of english learner summer school teachers and cost of english learner summer school teachers per district 
# create el_summer

il_fy22_additional_investments$el_summer <- il_fy22_additional_investments$el_final / il_fy22_cvs_additionalinvestment_el_clean$summerschool_teacher[1]

# create el_summer_cost

il_fy22_additional_investments$el_summer_cost <- il_fy22_additional_investments$el_summer * 68735.0

# Calculate number of english learner core teachers and cost of english learner core teachers per district 
# create el_core

il_fy22_additional_investments$el_core <- il_fy22_additional_investments$el_final / il_fy22_cvs_additionalinvestment_el_clean$english_learner_core_teacher[1]

# create el_core_cost

il_fy22_additional_investments$el_core_cost <- il_fy22_additional_investments$el_core * 68735.0


# CALCULATE SPECIAL EDUCATION INVESTMENTS 

# Calculate number of special ed teachers and cost of special ed teachers per district 
# create sped_teachers

il_fy22_additional_investments$sped_teacher <- il_fy22_additional_investments$tot_ase / il_fy22_cvs_additionalinvestment_sped_clean$sped_core_teacher[1]

# create sped_teachers_cost

il_fy22_additional_investments$sped_teacher_cost <- il_fy22_additional_investments$sped_teacher * 68735.0

# Calculate number of special ed instructional assistants and cost of special ed instructional assistants per district 
# create sped_assistant

il_fy22_additional_investments$sped_assistant <- il_fy22_additional_investments$tot_ase / il_fy22_cvs_additionalinvestment_sped_clean$instructional_assistant[1]

# create sped_assistant_cost

il_fy22_additional_investments$sped_assistant_cost <- il_fy22_additional_investments$sped_assistant * 27731.0

# Calculate number of special ed school psychologists and cost of special ed school psychologists per district 
# create sped_psychologist

il_fy22_additional_investments$sped_psychologist <- il_fy22_additional_investments$tot_ase / il_fy22_cvs_additionalinvestment_sped_clean$pyschologist[1]

# create sped_psychologist_cost

il_fy22_additional_investments$sped_psychologist_cost <- il_fy22_additional_investments$sped_psychologist * 77834.0

#CALCULATE TOTAL COST 

il_fy22_additional_investments$ai_total_cost <- il_fy22_additional_investments$li_intervention_cost + il_fy22_additional_investments$li_per_pupil_cost + il_fy22_additional_investments$li_extended_cost + il_fy22_additional_investments$li_summer_cost + il_fy22_additional_investments$el_intervention_cost + il_fy22_additional_investments$el_per_pupil_cost + il_fy22_additional_investments$el_extended_cost + il_fy22_additional_investments$el_summer_cost + il_fy22_additional_investments$el_core_cost + il_fy22_additional_investments$sped_teacher_cost + il_fy22_additional_investments$sped_assistant_cost + il_fy22_additional_investments$sped_psychologist_cost 

# Total cost with concentrated poverty

il_fy22_additional_investments$ai_w_cp_total_cost <- il_fy22_additional_investments$cp_intervention_cost + il_fy22_additional_investments$cp_per_pupil_support_cost + il_fy22_additional_investments$cp_extended_day_teacher_cost + il_fy22_additional_investments$cp_summer_school_teacher_cost + il_fy22_additional_investments$el_intervention_cost + il_fy22_additional_investments$el_per_pupil_cost + il_fy22_additional_investments$el_extended_cost + il_fy22_additional_investments$el_summer_cost + il_fy22_additional_investments$el_core_cost + il_fy22_additional_investments$sped_teacher_cost + il_fy22_additional_investments$sped_assistant_cost + il_fy22_additional_investments$sped_psychologist_cost

#Calculate FTE for substitute teacher cost determination “teacher salary” 

il_fy22_additional_investments$ai_total_fte <- il_fy22_additional_investments$li_intervention + il_fy22_additional_investments$li_extended + il_fy22_additional_investments$li_summer + il_fy22_additional_investments$el_intervention + il_fy22_additional_investments$el_extended + il_fy22_additional_investments$el_summer + il_fy22_additional_investments$el_core + il_fy22_additional_investments$sped_teacher

#Calculate FTE for substitute teacher cost determination “teacher salary” 

il_fy22_additional_investments$ai_w_cp_total_fte <- il_fy22_additional_investments$cp_intervention + il_fy22_additional_investments$cp_extended + il_fy22_additional_investments$cp_summer_school + il_fy22_additional_investments$el_intervention + il_fy22_additional_investments$el_extended + il_fy22_additional_investments$el_summer + il_fy22_additional_investments$el_core + il_fy22_additional_investments$sped_teacher

# Clean up workspace - delete row 923 (totals)

ebf_additional_investments <- il_fy22_additional_investments[-c(923),-c(2:34,36:38)]

rm(il_fy22_additional_investments,
   il_fy22_cvs_additionalinvestment_el_clean,
   il_fy22_cvs_additionalinvestment_el_raw,
   il_fy22_cvs_additionalinvestment_li_clean,
   il_fy22_cvs_additionalinvestment_li_raw,
   il_fy22_cvs_additionalinvestment_sped_clean,
   il_fy22_cvs_additionalinvestment_sped_raw,
   il_fy22_cvs_avgsalary_clean,
   il_fy22_cvs_avgsalary_raw,
   il_fy22_dist_join,
   il_fy22_enroll_all_clean,
   il_fy22_enroll_all_raw,
   il_fy22_enroll_el_clean,
   il_fy22_enroll_el_raw,
   il_fy22_enroll_li_clean,
   il_fy22_enroll_li_raw,
   temp_df,
   new_names,
   cp_diff,
   cp_extended_day_teacher,
   cp_extended_day_teacher_diff,
   cp_intervention_teacher,
   cp_intervention_teacher_diff,
   cp_per_pupil_support,
   cp_summer_school_diff,
   cp_summer_school_teacher,
   cp_support_teacher_diff,
   extended_day_teacher,
   intervention_teacher,
   per_pupil_support,
   summer_school_teacher)