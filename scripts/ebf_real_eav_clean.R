# PURPOSE ---------

#   This script will clean REAL EAV CALC and turn it into 
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

# Cleaning Real EAV --------

il_fy22_real_eav_raw <- read_excel("data/raw/FY22-EBF-Full-Calc-Revised.xlsx", sheet = 17,
                                    skip = 5)

# fix column names
il_fy22_real_eav_raw <- il_fy22_real_eav_raw |>
  # convert colnames to lowercase
  rename_with(tolower) 

# look at column names
names(il_fy22_real_eav_raw)

# new column names

# naming convention - delete# is the column number used to delete further
#                     down in the script

new_names <- c("distid",
               "distname",
               "origeav_19",
               "abatements_19",
               "ez_abatements_19",
               "ptab_adj_19",
               "coe_19",
               "real_eav_19",
               "delete9",
               "delete10")  # WE SHOULD TAKE A CLOSER LOOK AT THESE STEPS.

# manually replace column names
colnames(il_fy22_adjusted_eav_raw) <- new_names

# look at column names now
names(il_fy22_adjusted_eav_raw)

# delete columns

il_fy22_adjusted_eav_clean <- il_fy22_adjusted_eav_raw[,-c(3,6,10,12)]
