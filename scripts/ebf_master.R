# PURPOSE ---------

#   This script will bring two dataframes: 1) the Illinois Evidence Based Funding
#   (EBF) calculation and 2) the EBF calculation Team Illinois' policy intervention,
#   adding a concentrated poverty weight into the school funding formula.

#   This will be used for future analyses in R markup.

# PREPARED BY ------

# Chris Poulos

# 2022-08-27

# Let's go! - <('o' <)

# Bring in EBF calculations (current and Team Illinois policy intervention)

source("scripts/ebf_base_calc.R")

source("scripts/ebf_base_calc_intervention_concentrated_poverty.R")

# Note: There is likely an issue with the tier new appropriation calculation and the appropriation rate.
#       The total new state funding for any given fiscal year should be 300,000,000. The number for the 
#       EBF calculation is low (297,381,760), which is likely due to rounding, but the EBF calculation
#       when taking into account concentrated poverty is high (361,292,541). This might be due to
#       the allocation rate needing to be changed. In any given year, tier 1 schools should receive
#       30% of the new allocations, but the other tier allocation rates are variable based on the tier
#       1 funding (from my understanding). Adding the concentrated poverty rate might require us to
#       revise the allocation rates for Tiers 2-4 (Chris Poulos, 8/27/22)

# Calculations for presentation -----------------

# Totals differences

ci_sum <- sum(ebf_base_calc$ci_totalcost)
ci_cp_wgt_sum <- sum(ebf_base_calc_conpov$ci_totalcost)

ai_sum <- sum(ebf_base_calc$ai_total_cost)
ai_cp_wgt_sum <- sum(ebf_base_calc_conpov$ai_w_cp_total_cost)

ci_diff <- ci_cp_wgt_sum - ci_sum
ai_diff <- ai_cp_wgt_sum - ai_sum

fg_sum <- sum(ebf_base_calc$adequacy_funding_gap)
fg_cp_wgt_sum <- sum(ebf_base_calc_conpov$adequacy_funding_gap)

fg_diff <- fg_cp_wgt_sum - fg_sum

tab <- as.data.frame(matrix(c(ci_sum,ci_cp_wgt_sum,ci_diff,ai_sum,ai_cp_wgt_sum,ai_diff,fg_sum,fg_cp_wgt_sum,fg_diff), ncol=3, byrow = TRUE))

colnames(tab) <- c("Current EBF", "Concentrated Poverty Weight", "Difference")
rownames(tab) <- c("Core investments","Additional investments","Adequacy funding gap")

tab <- tibble::rownames_to_column(tab," ")

library(gt)
library(webshot)
webshot::install_phantomjs()

tab |>
  gt() |>
  tab_header(title = "EBF currently and with concentrated poverty weights, FY22, totals and differences") |>
  fmt_currency(columns=c("Current EBF", "Concentrated Poverty Weight", "Difference"),currency="USD") |>
  cols_align(align = c("center")) |>
  tab_source_note(source_note="Source: Illinois Evidence Base Funding Calculation, FY22 & Team Illinois calculations") |>
  gtsave("figures/EBF_totals_differences.png")

# Tier differences

tab2 <- ebf_base_calc |> group_by(tier) |> summarise(tier = n())
tab2 <- tibble::rownames_to_column(tab2,"Tier")
colnames(tab2) <- c("Tier", "EBF current")

tab3 <- ebf_base_calc_conpov |> group_by(tier) |> summarise(tier = n())
tab3 <- tibble::rownames_to_column(tab3,"Tier")
colnames(tab3) <- c("Tier", "EBF concentrated poverty weights")

tab4 <- tab2 |>
  left_join(tab3, id="Tier")

library(reshape2)

tab5 <- melt(tab4, id = "Tier")

colnames(tab5) <- c("Tier","EBF intervention","Count")

tab5 <- tab5 |>
  mutate(Tier_name = as.character(paste("Tier ",Tier)),
         Count_num = as.numeric(Count))

library(scales)

ggplot(tab5) +
  geom_col(aes(x = Tier_name, y = Count, fill = `EBF intervention`), 
           position = "dodge")  +
  labs(title = "School districts per tier",
       subtitle = "EBF currently & EBF with Concentrated Poverty Weights",
       x = "Tier",
       y = "Count",
       fill = "EBF intervention",
       caption = "Source: Illinois Evidence Base Funding Calculation, FY22 & Team Illinois calculations") +
  theme_bw()

ggsave(paste("figures/EBF_tier_counts.png"), units = "in", height = 5, width = 8)





