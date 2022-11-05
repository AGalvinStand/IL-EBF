# PURPOSE ---------

#   This script will produce a dataframe for Illinois Evidence Based Funding
#   formula (EBF) taking into account Team Illinois' policy intervention,
#   which is adding weights for concentrated poverty).

# PREPARED BY ------

# Chris Poulos

# 2022-08-26

# Let's go! - <('.' <)

# Bring in 4 key calculations ---------------------

source("scripts/ebf_core_investments_concentrated_poverty.R")
source("scripts/ebf_per_student_investments_simple.R")
source("scripts/ebf_additional_investments_concentrated_pov_weight.R")
source("scripts/ebf_local_cap_clean.R")

# Join dataframes

ebf_base_calc_conpov <- ebf_core_investments |>
  left_join(ebf_additional_investments, by = c("distid" = "distid")) |>
  left_join(ebf_local_capacity_target, by = c("distid" = "distid")) |>
  left_join(ebf_per_student_investments, by = c("distid" = "distid"))

rm(ebf_additional_investments,
   ebf_core_investments,
   ebf_local_capacity_target,
   ebf_per_student_investments)

# Stage 1: Determining Adequacy Level -------------

  # Adequacy target

ebf_base_calc_conpov <- ebf_base_calc_conpov |>
  mutate(adequacy_target =
           ci_totalcost + total_psi_cwi + ai_w_cp_total_cost + total_psi_nocwi)

# Final adequacy target

# Source CWI

source("scripts/ebf_region_factor_clean.R")

cwi <- il_fy22_region_factor_clean [,-c(2:15)]

ebf_base_calc_conpov <- ebf_base_calc_conpov |>
  left_join(cwi, by = c("distid" = "distid"))

ebf_base_calc_conpov <- ebf_base_calc_conpov |>
  mutate(final_adequacy_target =
           ((ci_totalcost + total_psi_cwi + ai_w_cp_total_cost)*region_factor_ebm) + total_psi_nocwi)

  # Per pupil final adequacy target

ebf_base_calc_conpov <- ebf_base_calc_conpov |>
  mutate(final_adequacy_target_per_pupil =
           final_adequacy_target/total_ase)

write_rds(ebf_base_calc_conpov,"scripts/shiny/ebf_sim/data/ebf_base_calc_conpov.rds")
