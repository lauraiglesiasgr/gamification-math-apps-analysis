# 06_descriptives.R - Descriptive statistics and prevalence by stratum.
library(dplyr); library(writexl)

model_vars <- c("LogMaxInstalls","V_Niveles","V_Recompensas",
                "V_Ranking","V_Avatares","V_Feedback",
                "Price","Rating_Adj","ADS_bin","IAP_bin","IGam")

desc_stats <- data.frame(
  Variable = model_vars,
  Mean = sapply(model_vars, function(v) round(mean(apps[[v]], na.rm = TRUE), 3)),
  SD   = sapply(model_vars, function(v) round(sd(apps[[v]],   na.rm = TRUE), 3)),
  Min  = sapply(model_vars, function(v) round(min(apps[[v]],  na.rm = TRUE), 3)),
  Max  = sapply(model_vars, function(v) round(max(apps[[v]],  na.rm = TRUE), 3))
)
write_xlsx(desc_stats, "outputs/descriptives.xlsx")

prevalence_by_stratum <- apps %>%
  group_by(EstratoPopularidad) %>%
  summarise(
    n = n(),
    pct_Levels   = round(mean(V_Niveles,     na.rm = TRUE) * 100, 1),
    pct_Rewards  = round(mean(V_Recompensas, na.rm = TRUE) * 100, 1),
    pct_Ranking  = round(mean(V_Ranking,     na.rm = TRUE) * 100, 1),
    pct_Avatars  = round(mean(V_Avatares,    na.rm = TRUE) * 100, 1),
    pct_Feedback = round(mean(V_Feedback,    na.rm = TRUE) * 100, 1),
    pct_IAP      = round(mean(IAP_bin,       na.rm = TRUE) * 100, 1),
    IGam_mean    = round(mean(IGam,          na.rm = TRUE), 2)
  )
write_xlsx(prevalence_by_stratum, "outputs/prevalence_by_stratum.xlsx")
