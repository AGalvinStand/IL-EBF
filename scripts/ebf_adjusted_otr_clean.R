# PURPOSE ---------

#   This script will clean ADJUSTED_EAV and turn it into 
#   a dataset for the EBF calculation.

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

# load il ebf raw data -  skip to row five. Referencing the FY22-EBF..xlsx
#                         to clean the column names

il_fy22_adjusted_otr_raw <- read_excel("data/raw/FY22-EBF-Full-Calc-Revised.xlsx", sheet = 15,
                                    skip = 5)

# fix column names
il_fy22_adjusted_otr_raw <- il_fy22_adjusted_otr_raw |>
  # convert colnames to lowercase
  rename_with(tolower) 

# look at column names
names(il_fy22_adjusted_otr_raw)

# new column names

# naming convention - delete# is the column number used to delete further
#                     down in the script

new_names <- c("distid",
               "distname",  # Confirm that RCDT is district id
               "ty_2019_otr",  #Not sure what TY is
               "real_eav_2019",
               "delete5",
               "exp_transpo_fy2020",
               "delete7",
               "rev_transpo_fy2020",
               "delete9",
               "tranporate", #deduction from otr
               "revsurplus", #binary
               "ty_2019_adjusted_otr",
               "delete13",
               "otr_finaladjusted_2019",
               "otr_final") # final 2019 adjusted otr for use in model (per $100 of eav)"

# manually replace column names
colnames(il_fy22_adjusted_otr_raw) <- new_names

# look at column names now
names(il_fy22_adjusted_otr_raw)

# look at district names - they are imported as characters!
glimpse(il_fy22_adjusted_otr_raw)

# delete unwanted columns

il_fy22_adjusted_otr_clean <- il_fy22_adjusted_otr_raw[,-c(5,7,9,13)]

