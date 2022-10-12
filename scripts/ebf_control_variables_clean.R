# PURPOSE ---------

#   This script will clean Control variables and turn it into 
#   a dataset for the EBF calculation.
#   NOTE: This will require creating multiple data frames.

# -------------

# PREPARED BY ------

# Chris Poulos

# 2022-07-26

# Vamos! - <('o' <)

#----------

# load ---------

options(scipen = 999)

library(tidyverse)
library(readxl)

# --------------

#             SHEET TABLE OF CONTENTS 
#--------------------------------------------
#       SHEET NAME          - SHEET NUMBER
#--------------------------------------------

# District Results Summary  - 1

# Base Calc                 - 2

# Control Variables         - 3

# Core Investments          - 4

# Per Student Investments   - 5

# Additional Investments    - 6

# Local Capacity Target     - 7

# Tier $                    - 8

# ENROLL-ALL                - 9

# ENROLL- LOW INCOME        - 10

# ENROLL - LI - ROE         - 11

#  ROE-LI Data              - 12

# ENROLL - EL               - 13

# REGION FACTOR             - 14

# ADJUSTED OTR              - 15

# ADJUSTED_EAV              - 16

# REAL EAV CALC             - 17

# PTELL EAV CALC            - 18

# FY 21 BFM                 - 19


# clean --------------

# load il ebf raw data -  skip to row three. Referencing the FY22-EBF..xlsx
#                         to clean the column names

# Prototypical school --------

il_fy22_cvs_protoschool_raw <- read_excel("data/raw/FY22-EBF-Full-Calc-Revised.xlsx", sheet = 3,
                                    skip = 2, n_max = 3)

# fix column names
il_fy22_cvs_protoschool_raw <- il_fy22_cvs_protoschool_raw |>
  # convert colnames to lowercase
  rename_with(tolower) 

# look at column names
names(il_fy22_cvs_protoschool_raw)

# new column names

# naming convention - delete# is the column number used to delete further
#                     down in the script

new_names <- c("prototypical_school",
               "noclue")  # I do not know what this number refers to

# manually replace column names
colnames(il_fy22_cvs_protoschool_raw) <- new_names

# look at column names now
names(il_fy22_cvs_protoschool_raw)

# delete columns

il_fy22_cvs_protoschool_clean <- il_fy22_cvs_protoschool_raw[,-c(3)]


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
               "core_teacher",
               "guidance_counselor",
               "social_worker",
               "school_psychologist",
               "librarian_mediaspecialist",
               "school_nurse",
               "principal",
               "assistant_principal")
               
# manually replace column names
colnames(il_fy22_cvs_avgsalary_raw) <- new_names

# look at column names now
names(il_fy22_cvs_avgsalary_raw)

# rename raw to clean

il_fy22_cvs_avgsalary_clean <- il_fy22_cvs_avgsalary_raw


# ASSUMED SALARIES -------------

il_fy22_cvs_assumedsalary_raw <- read_excel("data/raw/FY22-EBF-Full-Calc-Revised.xlsx", sheet = 3,
                                            skip = 13,n_max = 4)

# fix column names
il_fy22_cvs_assumedsalary_raw <- il_fy22_cvs_assumedsalary_raw |>
  # convert colnames to lowercase
  rename_with(tolower) 

# look at column names
names(il_fy22_cvs_assumedsalary_raw)

# new column names

# naming convention - delete# is the column number used to delete further
#                     down in the script

new_names <- c("grade",
               "school_site_staff",
               "noninstruction_assistant")

# manually replace column names
colnames(il_fy22_cvs_assumedsalary_raw) <- new_names

# look at column names now
names(il_fy22_cvs_assumedsalary_raw)

# rename raw to clean

il_fy22_cvs_assumedsalary_clean <- il_fy22_cvs_assumedsalary_raw

# CORE INVESTMENTS - CLASS SIZE --------

il_fy22_cvs_core_class_size_raw <- read_excel("data/raw/FY22-EBF-Full-Calc-Revised.xlsx", sheet = 3,
                                              skip = 20,n_max = 3)

# fix column names
il_fy22_cvs_core_class_size_raw <- il_fy22_cvs_core_class_size_raw |>
  # convert colnames to lowercase
  rename_with(tolower) 

# look at column names
names(il_fy22_cvs_core_class_size_raw)

# new column names

# naming convention - delete# is the column number used to delete further
#                     down in the script

new_names <- c("grade",
               "li",
               "nonli")

# manually replace column names
colnames(il_fy22_cvs_core_class_size_raw) <- new_names

# look at column names now
names(il_fy22_cvs_core_class_size_raw)

# rename raw to clean

il_fy22_cvs_core_class_size_clean <- il_fy22_cvs_core_class_size_raw

# CORE INVESTMENTS - INVESTMENTS (students to 1 fte) --------

il_fy22_cvs_core_investments_raw <- read_excel("data/raw/FY22-EBF-Full-Calc-Revised.xlsx", sheet = 3,
                                              skip = 26,n_max = 4)

# fix column names
il_fy22_cvs_core_investments_raw <- il_fy22_cvs_core_investments_raw |>
  # convert colnames to lowercase
  rename_with(tolower) 

# look at column names
names(il_fy22_cvs_core_investments_raw)

# new column names

# naming convention - delete# is the column number used to delete further
#                     down in the script

new_names <- c("grade",
               "specialists_per_of_coreteachers",
               "instructional_facilitators",
               "core_intervention_teacher",
               "guidance_counselor",
               "nurse",
               "supervisory_aide",
               "librarian",
               "librarian_aide",
               "principal",
               "assistant_principal",
               "school_site_staff")

# manually replace column names
colnames(il_fy22_cvs_core_investments_raw) <- new_names

# look at column names now
names(il_fy22_cvs_core_investments_raw)

# rename raw to clean

il_fy22_cvs_core_investments_clean <- il_fy22_cvs_core_investments_raw

# CORE INVESTMENTS - SUBSTITUTE TEACHER DAILY SALARY --------

il_fy22_cvs_core_subsalary_raw <- read_excel("data/raw/FY22-EBF-Full-Calc-Revised.xlsx", sheet = 3,
                                               skip = 32,n_max = 4)

# fix column names
il_fy22_cvs_core_subsalary_raw <- il_fy22_cvs_core_subsalary_raw |>
  # convert colnames to lowercase
  rename_with(tolower) 

# look at column names
names(il_fy22_cvs_core_subsalary_raw)

# new column names

# naming convention - delete# is the column number used to delete further
#                     down in the script

new_names <- c("subtype",
               "daily_salary")

# manually replace column names
colnames(il_fy22_cvs_core_subsalary_raw) <- new_names

# look at column names now
names(il_fy22_cvs_core_subsalary_raw)

# rename raw to clean

il_fy22_cvs_core_subsalary_clean <- il_fy22_cvs_core_subsalary_raw

# PER STUDENT INVESTMENTS - INVESTMENTS PER STUDENT  --------

il_fy22_cvs_perstudent_investment_perstudent_raw <- read_excel("data/raw/FY22-EBF-Full-Calc-Revised.xlsx", sheet = 3,
                                             skip = 41,n_max = 4)

# fix column names
il_fy22_cvs_perstudent_investment_perstudent_raw <- il_fy22_cvs_perstudent_investment_perstudent_raw |>
  # convert colnames to lowercase
  rename_with(tolower) 

# look at column names
names(il_fy22_cvs_perstudent_investment_perstudent_raw)

# new column names

# naming convention - delete# is the column number used to delete further
#                     down in the script

new_names <- c("grade",
               "gifted",
               "professional_development",
               "instructional_material",
               "assessments",
               "tech",
               "student_activities")

# manually replace column names
colnames(il_fy22_cvs_perstudent_investment_perstudent_raw) <- new_names

# look at column names now
names(il_fy22_cvs_perstudent_investment_perstudent_raw)

# rename raw to clean

il_fy22_cvs_perstudent_investment_perstudent_clean <- il_fy22_cvs_perstudent_investment_perstudent_raw

# PER STUDENT INVESTMENTS - CENTRAL SERVCES  --------

il_fy22_cvs_perstudent_centralservices_raw <- read_excel("data/raw/FY22-EBF-Full-Calc-Revised.xlsx", sheet = 3,
                                                               skip = 47,n_max = 3)

# fix column names
il_fy22_cvs_perstudent_centralservices_raw <- il_fy22_cvs_perstudent_centralservices_raw |>
  # convert colnames to lowercase
  rename_with(tolower) 

# look at column names
names(il_fy22_cvs_perstudent_centralservices_raw)

# new column names

# naming convention - delete# is the column number used to delete further
#                     down in the script

new_names <- c("grade",
               "maint_ops",
               "central_office",
               "employee_benefits",
               "employee_benefits_central",
               "employee_benefits_maint_ops")

# manually replace column names
colnames(il_fy22_cvs_perstudent_centralservices_raw) <- new_names

# look at column names now
names(il_fy22_cvs_perstudent_centralservices_raw)

# rename raw to clean

il_fy22_cvs_perstudent_centralservices_clean <- il_fy22_cvs_perstudent_centralservices_raw

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

# Remove raw data frames. Using fm to force through if 

rm(il_fy22_cvs_additionalinvestment_el_raw,
   il_fy22_cvs_additionalinvestment_li_raw,
   il_fy22_cvs_additionalinvestment_sped_raw,
   il_fy22_cvs_assumedsalary_raw,
   il_fy22_cvs_avgsalary_raw,
   il_fy22_cvs_core_class_size_raw,
   il_fy22_cvs_core_investments_raw,
   il_fy22_cvs_core_subsalary_raw,
   il_fy22_cvs_perstudent_centralservices_raw,
   il_fy22_cvs_perstudent_investment_perstudent_raw,
   il_fy22_cvs_protoschool_raw)
