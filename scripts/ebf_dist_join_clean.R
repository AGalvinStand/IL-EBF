# PURPOSE ---------

#   This script will clean ENROLL-ALL sheet and turn it into a 
#   dataset for the EBF calculation.

# -------------

# PREPARED BY ------

# Chris Poulos

# 2022-07-26

# Let's go! - <('.' <)

#----------

# load ---------

options(scipen = 999)

library(tidyverse)
library(readxl)

# --------------

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

il_fy22_dist_join <- read_excel("data/raw/FY22-EBF-Full-Calc-Revised.xlsx", sheet = 2,
                                skip = 10)



# fix column names
il_fy22_dist_join |> il_fy22_dist_join
  # convert colnames to lowercase
  rename_with(tolower) 

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
