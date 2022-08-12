# PURPOSE ---------

#   This script will perform the core investmetns calculation.

# -------------

# PREPARED BY ------

# Chris Poulos

# 2022-08-09

# Let's go! - <('.' <)

#----------

# load ---------

options(scipen = 999)

library(tidyverse)
library(readxl)

# CORE INVESTMENTS - STEPS

# Create ---------
# Outline --------
# Blah -----------

source("scripts/ebf_enroll_li_clean.R")
#source("scripts/ebf_enroll_all_clean.R")
source("scripts/ebf_control_variables_clean.R")

# CORE TEACHER AMOUNT------


#Core teachers per student by grade

gk_3 <- il_fy22_cvs_core_class_size_clean$grade == "K-3"
g4_12 <- il_fy22_cvs_core_class_size_clean$grade == "4-12"


ebf_core_investments_fy22 <- il_fy22_enroll_li_clean |>
  mutate(fte_coreteacher_k_3 = (enroll_k_3_li/il_fy22_cvs_core_class_size_clean$li[gk_3])+(enroll_k_3_noli/il_fy22_cvs_core_class_size_clean$nonli[gk_3]),
         fte_coreteacher_4_8 = (enroll_4_8_li/il_fy22_cvs_core_class_size_clean$li[g4_12])+(enroll_4_8_noli/il_fy22_cvs_core_class_size_clean$nonli[g4_12]),
         fte_coreteacher_9_12 = (enroll_9_12_li/il_fy22_cvs_core_class_size_clean$li[g4_12])+(enroll_9_12_noli/il_fy22_cvs_core_class_size_clean$nonli[g4_12]))


# Core teacher amount (salarly times fte core teachers per student)

gk_8 = il_fy22_cvs_avgsalary_clean$grade == "Elementary (K - 8) (NO PK)"
g9_12 = il_fy22_cvs_avgsalary_clean$grade == "High School (9 - 12)"

k8_coreteacher_salary <- il_fy22_cvs_avgsalary_clean$core_teacher[gk_8]
hs_coreteacher_salary <- il_fy22_cvs_avgsalary_clean$core_teacher[g9_12]

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(core_teacher_cost = 
           (fte_coreteacher_k_3*k8_coreteacher_salary)+
           (fte_coreteacher_4_8*k8_coreteacher_salary)+
           (fte_coreteacher_9_12*hs_coreteacher_salary))

# SPECIALIST TEACHER COST ----------

# Specialist Teacher % of Core Teacher

gpk_5 <- il_fy22_cvs_core_investments_clean$grade == "Elementary (PK - 5)"
gmiddle <- il_fy22_cvs_core_investments_clean$grade == "Middle"
ghs <- il_fy22_cvs_core_investments_clean$grade == "High School"

specialists_pk_5 <- il_fy22_cvs_core_investments_clean$specialists_per_of_coreteachers[gpk_5]
specialists_middle <- il_fy22_cvs_core_investments_clean$specialists_per_of_coreteachers[gmiddle]
specialists_hs <- il_fy22_cvs_core_investments_clean$specialists_per_of_coreteachers[ghs]

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(fte_specialists = 
           (specialists_pk_5*fte_coreteacher_k_3)+
           (specialists_middle*fte_coreteacher_4_8)+
           (specialists_hs*fte_coreteacher_9_12))

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(specialist_cost = 
           (specialists_pk_5*fte_coreteacher_k_3*k8_coreteacher_salary)+
           (specialists_middle*fte_coreteacher_4_8*k8_coreteacher_salary)+
           (specialists_hs*fte_coreteacher_9_12*hs_coreteacher_salary))

# INSTRUCTIONAL FACILITATOR COST -----------------

source("scripts/ebf_enroll_all_clean.R")

instructional_facilitator_pk_5 <- il_fy22_cvs_core_investments_clean$instructional_facilitators[gpk_5]
instructional_facilitator_middle <- il_fy22_cvs_core_investments_clean$instructional_facilitators[gmiddle]
instructional_facilitator_hs <- il_fy22_cvs_core_investments_clean$instructional_facilitators[ghs]

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  left_join(il_fy22_enroll_all_clean, by = c("distid" = "distid")) 

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(fte_instructional_facilitator_pk_5 =
           (enroll_school_elem_pk_5/instructional_facilitator_pk_5),
         fte_instructional_facilitator_middle =
           (enroll_school_mid_6_8/instructional_facilitator_middle),
         fte_instructional_facilitator_hs =
           (enroll_school_hs_9_12/instructional_facilitator_hs))

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(instructional_facilitator_cost = 
           (fte_instructional_facilitator_pk_5* k8_coreteacher_salary)+
           (fte_instructional_facilitator_middle * k8_coreteacher_salary)+
           (fte_instructional_facilitator_hs * hs_coreteacher_salary))

# CORE INTERVENTION TEACHER (Tutor) COST ---------

core_intervention_pk_5 <- il_fy22_cvs_core_investments_clean$core_intervention_teacher[gpk_5]
core_intervention_middle <- il_fy22_cvs_core_investments_clean$core_intervention_teacher[gmiddle]
core_intervention_hs <- il_fy22_cvs_core_investments_clean$core_intervention_teacher[ghs]

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(fte_core_intervention_pk_5 =
           (enroll_school_elem_pk_5/core_intervention_pk_5),
         fte_core_intervention_middle =
           (enroll_school_mid_6_8/core_intervention_middle),
         fte_core_intervention_hs =
           (enroll_school_hs_9_12/core_intervention_hs))

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(core_intervention_cost = 
           (fte_core_intervention_pk_5* k8_coreteacher_salary)+
           (fte_core_intervention_middle * k8_coreteacher_salary)+
           (fte_core_intervention_hs * hs_coreteacher_salary))

# SUBSTITUTE TEACHER COST ------------------------

# NEED ADDITIONAL INVESTMENT COL 51 AND 42

# GUIDANCE COUNSELOR COST ------------------------

guidance_counselor_pk_5 <- il_fy22_cvs_core_investments_clean$guidance_counselor[gpk_5]
guidance_counselor_middle <- il_fy22_cvs_core_investments_clean$guidance_counselor[gmiddle]
guidance_counselor_hs <- il_fy22_cvs_core_investments_clean$guidance_counselor[ghs]

k8_guidance_counselor_salary <- il_fy22_cvs_avgsalary_clean$guidance_counselor[gk_8]
hs_guidance_counselor_salary <- il_fy22_cvs_avgsalary_clean$guidance_counselor[g9_12]

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(fte_guidance_counselor_pk_5 =
           (enroll_school_elem_pk_5/guidance_counselor_pk_5),
         fte_guidance_counselor_middle =
           (enroll_school_mid_6_8/guidance_counselor_middle),
         fte_guidance_counselor_hs =
           (enroll_school_hs_9_12/guidance_counselor_hs))

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(guidance_counselor_cost = 
           (fte_guidance_counselor_pk_5* k8_guidance_counselor_salary)+
           (fte_guidance_counselor_middle * k8_guidance_counselor_salary)+
           (fte_guidance_counselor_hs * hs_guidance_counselor_salary))

# NURSE COST -------------------------------------

school_nurse_pk_5 <- il_fy22_cvs_core_investments_clean$nurse[gpk_5]
school_nurse_middle <- il_fy22_cvs_core_investments_clean$nurse[gmiddle]
school_nurse_hs <- il_fy22_cvs_core_investments_clean$nurse[ghs]

k8_school_nurse_salary <- il_fy22_cvs_avgsalary_clean$school_nurse[gk_8]
hs_school_nurse_salary <- il_fy22_cvs_avgsalary_clean$school_nurse[g9_12]

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(fte_school_nurse_pk_5 =
           (enroll_school_elem_pk_5/school_nurse_pk_5),
         fte_school_nurse_middle =
           (enroll_school_mid_6_8/school_nurse_middle),
         fte_school_nurse_hs =
           (enroll_school_hs_9_12/school_nurse_hs))

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(school_nurse_cost = 
           (fte_school_nurse_pk_5* k8_school_nurse_salary)+
           (fte_school_nurse_middle * k8_school_nurse_salary)+
           (fte_school_nurse_hs * hs_school_nurse_salary))

# SUPERVISORY AIDE COST --------------------------

supervisory_aide_pk_5 <- il_fy22_cvs_core_investments_clean$supervisory_aide[gpk_5]
supervisory_aide_middle <- il_fy22_cvs_core_investments_clean$supervisory_aide[gmiddle]
supervisory_aide_hs <- il_fy22_cvs_core_investments_clean$supervisory_aide[ghs]

k8_supervisory_aide_salary <- il_fy22_cvs_assumedsalary_clean$noninstruction_assistant[gk_8]
hs_supervisory_aide_salary <- il_fy22_cvs_assumedsalary_clean$noninstruction_assistant[g9_12]

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(fte_supervisory_aide_pk_5 =
           (enroll_school_elem_pk_5/supervisory_aide_pk_5),
         fte_supervisory_aide_middle =
           (enroll_school_mid_6_8/supervisory_aide_middle),
         fte_supervisory_aide_hs =
           (enroll_school_hs_9_12/supervisory_aide_hs))

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(supervisory_aide_cost = 
           (fte_supervisory_aide_pk_5* k8_supervisory_aide_salary)+
           (fte_supervisory_aide_middle * k8_supervisory_aide_salary)+
           (fte_supervisory_aide_hs * hs_supervisory_aide_salary))

# LIBRARIAN COST ---------------------------------

librarian_pk_5 <- il_fy22_cvs_core_investments_clean$librarian[gpk_5]
librarian_middle <- il_fy22_cvs_core_investments_clean$librarian[gmiddle]
librarian_hs <- il_fy22_cvs_core_investments_clean$librarian[ghs]

k8_librarian_salary <- il_fy22_cvs_avgsalary_clean$librarian_mediaspecialist[gk_8]
hs_librarian_salary <- il_fy22_cvs_avgsalary_clean$librarian_mediaspecialist[g9_12]

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(fte_librarian_pk_5 =
           (enroll_school_elem_pk_5/librarian_pk_5),
         fte_librarian_middle =
           (enroll_school_mid_6_8/librarian_middle),
         fte_librarian_hs =
           (enroll_school_hs_9_12/librarian_hs))

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(librarian_cost = 
           (fte_librarian_pk_5* k8_librarian_salary)+
           (fte_librarian_middle * k8_librarian_salary)+
           (fte_librarian_hs * hs_librarian_salary))

# LIBRARIAN AIDE / MEDIA TECH COST ---------------

librarian_aide_pk_5 <- il_fy22_cvs_core_investments_clean$librarian_aide[gpk_5]
librarian_aide_middle <- il_fy22_cvs_core_investments_clean$librarian_aide[gmiddle]
librarian_aide_hs <- il_fy22_cvs_core_investments_clean$librarian_aide[ghs]

k8_librarian_aide_salary <- il_fy22_cvs_assumedsalary_clean$noninstruction_assistant[gk_8]
hs_librarian_aide_salary <- il_fy22_cvs_assumedsalary_clean$noninstruction_assistant[g9_12]

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(fte_librarian_aide_pk_5 =
           (enroll_school_elem_pk_5/librarian_aide_pk_5),
         fte_librarian_aide_middle =
           (enroll_school_mid_6_8/librarian_aide_middle),
         fte_librarian_aide_hs =
           (enroll_school_hs_9_12/librarian_aide_hs))

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(librarian_aide_cost = 
           (fte_librarian_aide_pk_5* k8_librarian_aide_salary)+
           (fte_librarian_aide_middle * k8_librarian_aide_salary)+
           (fte_librarian_aide_hs * hs_librarian_aide_salary))

# PRINCIPAL COST ---------------------------------

principal_pk_5 <- il_fy22_cvs_core_investments_clean$principal[gpk_5]
principal_middle <- il_fy22_cvs_core_investments_clean$principal[gmiddle]
principal_hs <- il_fy22_cvs_core_investments_clean$principal[ghs]

k8_principal_salary <- il_fy22_cvs_avgsalary_clean$principal[gk_8]
hs_principal_salary <- il_fy22_cvs_avgsalary_clean$principal[g9_12]

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(fte_principal_pk_5 =
           (enroll_school_elem_pk_5/principal_pk_5),
         fte_principal_middle =
           (enroll_school_mid_6_8/principal_middle),
         fte_principal_hs =
           (enroll_school_hs_9_12/principal_hs))

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(principal_cost = 
           (fte_principal_pk_5* k8_principal_salary)+
           (fte_principal_middle * k8_principal_salary)+
           (fte_principal_hs * hs_principal_salary))

# ASSISTANT PRINCIPAL COST -----------------------

assistant_principal_pk_5 <- il_fy22_cvs_core_investments_clean$assistant_principal[gpk_5]
assistant_principal_middle <- il_fy22_cvs_core_investments_clean$assistant_principal[gmiddle]
assistant_principal_hs <- il_fy22_cvs_core_investments_clean$assistant_principal[ghs]

k8_assistant_principal_salary <- il_fy22_cvs_avgsalary_clean$assistant_principal[gk_8]
hs_assistant_principal_salary <- il_fy22_cvs_avgsalary_clean$assistant_principal[g9_12]

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(fte_assistant_principal_pk_5 =
           (enroll_school_elem_pk_5/assistant_principal_pk_5),
         fte_assistant_principal_middle =
           (enroll_school_mid_6_8/assistant_principal_middle),
         fte_assistant_principal_hs =
           (enroll_school_hs_9_12/assistant_principal_hs))

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(assistant_principal_cost = 
           (fte_assistant_principal_pk_5* k8_assistant_principal_salary)+
           (fte_assistant_principal_middle * k8_assistant_principal_salary)+
           (fte_assistant_principal_hs * hs_assistant_principal_salary))

# SCHOOL SITE STAFF COST -------------------------

school_site_staff_pk_5 <- il_fy22_cvs_core_investments_clean$school_site_staff[gpk_5]
school_site_staff_middle <- il_fy22_cvs_core_investments_clean$school_site_staff[gmiddle]
school_site_staff_hs <- il_fy22_cvs_core_investments_clean$school_site_staff[ghs]

k8_school_site_staff_salary <- il_fy22_cvs_assumedsalary_clean$school_site_staff[gk_8]
hs_school_site_staff_salary <- il_fy22_cvs_assumedsalary_clean$school_site_staff[g9_12]

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(fte_school_site_staff_pk_5 =
           (enroll_school_elem_pk_5/school_site_staff_pk_5),
         fte_school_site_staff_middle =
           (enroll_school_mid_6_8/school_site_staff_middle),
         fte_school_site_staff_hs =
           (enroll_school_hs_9_12/school_site_staff_hs))

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(school_site_staff_cost = 
           (fte_school_site_staff_pk_5* k8_school_site_staff_salary)+
           (fte_school_site_staff_middle * k8_school_site_staff_salary)+
           (fte_school_site_staff_hs * hs_school_site_staff_salary))

# TOTAL COST -------------------------------------

# TOTAL SALARY COST (LESS SUBSTITUTES) -----------

