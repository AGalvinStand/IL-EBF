# PURPOSE ---------

#   This script will clean ENROLL - EL and turn it into 
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

# load il ebf raw data -  skip to row four. Referencing the FY22-EBF..xlsx
#                         to clean the column names

il_fy23_enroll_el_raw <- read_excel("C:/Users/jpacas/Documents/GitHub/IL-EBF/data/raw/FY-23-Evidence-Based-Funding-Full-Calc.xlsx", sheet = 13,
                                    skip = 5, n_max = 927)

# fix column names
il_fy23_enroll_el_raw <- il_fy23_enroll_el_raw |>
  # convert colnames to lowercase
  rename_with(tolower) 

# look at column names
names(il_fy23_enroll_el_raw)

# new column names

# naming convention - delete# is the column number used to delete further
#                     down in the script

new_names <- c("distid",
               "distname",  # Confirm that RCDT is district id
               "el_2020",
               "el_2021",
               "el_2022",
               "delete6",
               "el_3yravg",
               "delete8",
               "el_final", # Final el count (greater of current year or 3 year average)
               "selected")

# manually replace column names
colnames(il_fy23_enroll_el_raw) <- new_names

# look at column names now
names(il_fy23_enroll_el_raw)

# look at district names - they are imported as characters!
glimpse(il_fy23_enroll_li_raw$distid)

# delete unwanted columns

il_fy23_enroll_el_clean <- il_fy23_enroll_el_raw[,-c(6,8)]

