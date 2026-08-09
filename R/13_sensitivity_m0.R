# 13_sensitivity_m0.R - Sensitivity of Model I to the m0 threshold.
library(sandwich); library(lmtest); library(writexl)

m0_values <- c(50, 75, 100, 130, 200, 300)
sens_results <- data.frame(
  m0 = m0_values, beta_rating = NA_real_, p_rating = NA_real_,
  beta_rewards = NA_real_, p_rewards = NA_real_,
  beta_IAP = NA_real_, R2_adj = NA_real_)

vi <- apps$`Rating Count`
Ri <- apps$Rating
C  <- mean(Ri, na.rm = TRUE)

for (i in seq_along(m0_values)) {
  m0_i <- m0_values[i]
  apps$Rating_Adj_i <- (vi / (vi + m0_i)) * Ri + (m0_i / (vi + m0_i)) * C
  m_i <- lm(LogMaxInstalls ~ V_Niveles + V_Recompensas + V_Ranking +
              V_Avatares + V_Feedback + Price + Rating_Adj_i +
              ADS_bin + IAP_bin, data = apps)
  ct <- coeftest(m_i, vcov = vcovHC(m_i, type = "HC3"))
  sens_results$beta_rating[i]  <- round(ct["Rating_Adj_i", "Estimate"], 3)
  sens_results$p_rating[i]     <- round(ct["Rating_Adj_i", "Pr(>|t|)"], 4)
  sens_results$beta_rewards[i] <- round(ct["V_Recompensas", "Estimate"], 3)
  sens_results$p_rewards[i]    <- round(ct["V_Recompensas", "Pr(>|t|)"], 4)
  sens_results$beta_IAP[i]     <- round(ct["IAP_bin", "Estimate"], 3)
  sens_results$R2_adj[i]       <- round(summary(m_i)$adj.r.squared, 4)
}
print(sens_results)
write_xlsx(sens_results, "outputs/sensitivity_m0.xlsx")
