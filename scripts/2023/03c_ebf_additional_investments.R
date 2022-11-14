# PURPOSE ---------

#   This script will calculate additional investments in the EBF formula.

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

# ADDITIONAL INVESTMENTS - LOW INCOME  --------

# ADDITIONAL INVESTMENTS - ENGLISH LEARNER  --------

# ADDITIONAL INVESTMENTS - SPECIAL EDUCATION  --------

source("01a_ebf_control_variables_clean.R")
source("01b_ebf_enroll_all_clean.R")
source("01c_ebf_enroll_li_clean.R")
source("01e_ebf_enroll_el_clean.R")

# clean district id data --------------
source("02_ebf_dist_join_clean.R")

il_fy23_enroll_li_clean <- il_fy23_enroll_li_clean[c('distid','dhs_final')]


# merging enrollment data

temp_df <- merge(il_fy23_enroll_all_clean, il_fy23_enroll_li_clean, by = 'distid')

il_fy23_additional_investments <- merge(temp_df, il_fy23_enroll_el_clean, by = 'distid')

# CALCULATE LOW INCOME INVESTMENTS 

# Calculate number of low-income intervention teachers and cost of low-income intervention teachers per district 
# create li_intervention

il_fy23_additional_investments$li_intervention <- il_fy23_additional_investments$dhs_final / il_fy23_cvs_additionalinvestment_li_clean$intervention_teacher[1]

il_fy23_cvs_avgsalary_clean$core_teacher[3]

# create li_intervention_cost

il_fy23_additional_investments$li_intervention_cost <- il_fy23_additional_investments$li_intervention * il_fy23_cvs_avgsalary_clean$core_teacher[3]

# Calculate number of low-income per pupil supports and cost of low-income per pupil supports per district 
# create li_per_pupil

il_fy23_additional_investments$li_per_pupil <- il_fy23_additional_investments$dhs_final / il_fy23_cvs_additionalinvestment_li_clean$pupil_support[1]

# create li_per_pupil_cost

il_fy23_additional_investments$li_per_pupil_cost <- il_fy23_additional_investments$li_per_pupil * il_fy23_cvs_avgsalary_clean$core_teacher[3]

# Calculate number of low-income extended day teachers and cost of low-income extended day teachers per district 
# create li_extended

il_fy23_additional_investments$li_extended <- il_fy23_additional_investments$dhs_final / il_fy23_cvs_additionalinvestment_li_clean$extended_day_teacher[1]

# create li_extended_cost

il_fy23_additional_investments$li_extended_cost <- il_fy23_additional_investments$li_extended * il_fy23_cvs_avgsalary_clean$core_teacher[3]

# Calculate number of low-income summer school teachers and cost of low-income summer school teachers per district 
# create li_summer

il_fy23_additional_investments$li_summer <- il_fy23_additional_investments$dhs_final / il_fy23_cvs_additionalinvestment_li_clean$summerschool_teacher[1]

# create li_summer_cost

il_fy23_additional_investments$li_summer_cost <- il_fy23_additional_investments$li_summer * il_fy23_cvs_avgsalary_clean$core_teacher[3]

#CALCULATE ENGLISH LEARNER INVESTMENTS 

# Calculate number of english learner intervention teachers and cost of english learner intervention teachers per district 
# create el_intervention

il_fy23_additional_investments$el_intervention <- il_fy23_additional_investments$el_final / il_fy23_cvs_additionalinvestment_el_clean$intervention_teacher[1]

# create el_intervention_cost

il_fy23_additional_investments$el_intervention_cost <- il_fy23_additional_investments$el_intervention * il_fy23_cvs_avgsalary_clean$core_teacher[3]

# Calculate number of english learner per pupil supports and cost of english learner per pupil supports per district 
# create el_per_pupil

il_fy23_additional_investments$el_per_pupil <- il_fy23_additional_investments$el_final / il_fy23_cvs_additionalinvestment_el_clean$pupil_support[1]

# create el_per_pupil_cost

il_fy23_additional_investments$el_per_pupil_cost <- il_fy23_additional_investments$el_per_pupil * il_fy23_cvs_avgsalary_clean$core_teacher[3]

# Calculate number of english learner extended day teachers and cost of english learner extended day teachers per district 
# create el_extended

il_fy23_additional_investments$el_extended <- il_fy23_additional_investments$el_final / il_fy23_cvs_additionalinvestment_el_clean$extended_day_teacher[1]

# create el_extended_cost

il_fy23_additional_investments$el_extended_cost <- il_fy23_additional_investments$el_extended * il_fy23_cvs_avgsalary_clean$core_teacher[3]

# Calculate number of english learner summer school teachers and cost of english learner summer school teachers per district 
# create el_summer

il_fy23_additional_investments$el_summer <- il_fy23_additional_investments$el_final / il_fy23_cvs_additionalinvestment_el_clean$summerschool_teacher[1]

# create el_summer_cost

il_fy23_additional_investments$el_summer_cost <- il_fy23_additional_investments$el_summer * il_fy23_cvs_avgsalary_clean$core_teacher[3]

# Calculate number of english learner core teachers and cost of english learner core teachers per district 
# create el_core

il_fy23_additional_investments$el_core <- il_fy23_additional_investments$el_final / il_fy23_cvs_additionalinvestment_el_clean$english_learner_core_teacher[1]

# create el_core_cost

il_fy23_additional_investments$el_core_cost <- il_fy23_additional_investments$el_core * il_fy23_cvs_avgsalary_clean$core_teacher[3]


# CALCULATE SPECIAL EDUCATION INVESTMENTS 

# Calculate number of special ed teachers and cost of special ed teachers per district 
# create sped_teachers

il_fy23_additional_investments$sped_teacher <- il_fy23_additional_investments$tot_ase / il_fy23_cvs_additionalinvestment_sped_clean$sped_core_teacher[1]

# create sped_teachers_cost

il_fy23_additional_investments$sped_teacher_cost <- il_fy23_additional_investments$sped_teacher * il_fy23_cvs_avgsalary_clean$core_teacher[3]

# Calculate number of special ed instructional assistants and cost of special ed instructional assistants per district 
# create sped_assistant

il_fy23_additional_investments$sped_assistant <- il_fy23_additional_investments$tot_ase / il_fy23_cvs_additionalinvestment_sped_clean$instructional_assistant[1]

# create sped_assistant_cost

il_fy23_additional_investments$sped_assistant_cost <- il_fy23_additional_investments$sped_assistant * il_fy23_cvs_assumedsalary_clean$noninstruction_assistant[3]

# Calculate number of special ed school psychologists and cost of special ed school psychologists per district 
# create sped_psychologist

il_fy23_additional_investments$sped_psychologist <- il_fy23_additional_investments$tot_ase / il_fy23_cvs_additionalinvestment_sped_clean$pyschologist[1]

# create sped_psychologist_cost

il_fy23_additional_investments$sped_psychologist_cost <- il_fy23_additional_investments$sped_psychologist * il_fy23_cvs_avgsalary_clean$school_psychologist[3]
#CALCULATE TOTAL COST 

il_fy23_additional_investments$ai_total_cost <- il_fy23_additional_investments$li_intervention_cost + il_fy23_additional_investments$li_per_pupil_cost + il_fy23_additional_investments$li_extended_cost + il_fy23_additional_investments$li_summer_cost + il_fy23_additional_investments$el_intervention_cost + il_fy23_additional_investments$el_per_pupil_cost + il_fy23_additional_investments$el_extended_cost + il_fy23_additional_investments$el_summer_cost + il_fy23_additional_investments$el_core_cost + il_fy23_additional_investments$sped_teacher_cost + il_fy23_additional_investments$sped_assistant_cost + il_fy23_additional_investments$sped_psychologist_cost 

#Calculate FTE for substitute teacher cost determination “teacher salary” 

il_fy23_additional_investments$ai_total_fte <- il_fy23_additional_investments$li_intervention + il_fy23_additional_investments$li_extended + il_fy23_additional_investments$li_summer + il_fy23_additional_investments$el_intervention + il_fy23_additional_investments$el_extended + il_fy23_additional_investments$el_summer + il_fy23_additional_investments$el_core + il_fy23_additional_investments$sped_teacher


# Clean up workspace

ebf_additional_investments <- il_fy23_additional_investments[,-c(2:25,27:29)]

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
   new_names)