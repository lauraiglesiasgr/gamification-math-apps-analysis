# 12_robustness_rewards.R - Robustness of the Rewards coefficient + TOST.
library(sandwich); library(lmtest); library(boot); library(car); library(TOSTER)

# 1. Re-estimate Model I without influential observations
cook      <- cooks.distance(model_I)
threshold <- 4 / nrow(apps)
apps_no_infl  <- apps[cook <= threshold, ]
model_no_infl <- lm(LogMaxInstalls ~ V_Niveles + V_Recompensas +
                      V_Ranking + V_Avatares + V_Feedback +
                      Price + Rating_Adj + ADS_bin + IAP_bin,
                    data = apps_no_infl)
coeftest(model_no_infl, vcov = vcovHC(model_no_infl, type = "HC3"))
cat("Adjusted R2 without influential:",
    round(summary(model_no_infl)$adj.r.squared, 4), "\n")

# 2. Non-parametric bootstrap (1,000 resamples) on the Rewards coefficient
boot_fn <- function(data, indices) {
  d <- data[indices, ]
  m <- lm(LogMaxInstalls ~ V_Niveles + V_Recompensas +
            V_Ranking + V_Avatares + V_Feedback + Price +
            Rating_Adj + ADS_bin + IAP_bin, data = d)
  coef(m)["V_Recompensas"]
}
set.seed(42)
boot_res <- boot(apps, boot_fn, R = 1000)
print(boot.ci(boot_res, type = c("perc", "bca")))

# 3. Exact Fisher test: Stratum x Rewards
tbl <- table(apps$EstratoPopularidad, apps$V_Recompensas)
print(tbl)
fisher.test(tbl)

# 4. TOST equivalence tests for Levels and Ranking (delta = 0.3, Cohen's d)
ct <- coeftest(model_I, vcov = vcovHC(model_I, type = "HC3"))
beta_levels  <- ct["V_Niveles", "Estimate"]; se_levels  <- ct["V_Niveles", "Std. Error"]
beta_ranking <- ct["V_Ranking", "Estimate"]; se_ranking <- ct["V_Ranking", "Std. Error"]
delta <- 0.3

tost_levels <- tsum_TOST(
  m1 = beta_levels, sd1 = se_levels * sqrt(200), n1 = 200,
  hypothesis = "EQU", low_eqbound = -delta, high_eqbound = delta,
  alpha = 0.05, eqbound_type = "raw")
tost_ranking <- tsum_TOST(
  m1 = beta_ranking, sd1 = se_ranking * sqrt(200), n1 = 200,
  hypothesis = "EQU", low_eqbound = -delta, high_eqbound = delta,
  alpha = 0.05, eqbound_type = "raw")
print(tost_levels)
print(tost_ranking)
