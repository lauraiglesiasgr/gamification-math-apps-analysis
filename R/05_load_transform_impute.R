# 05_load_transform_impute.R - Load coded sample, transform, impute, indices.
library(readxl); library(dplyr)

apps <- read_excel("data/muestra_200_RECONCILIADA.xlsx",
                   sheet = "CODIFICACION")

apps <- apps %>%
  mutate(
    V_Niveles     = as.integer(V_Niveles),
    V_Recompensas = as.integer(V_Recompensas),
    V_Ranking     = as.integer(V_Ranking),
    V_Avatares    = as.integer(V_Avatares),
    V_Feedback    = as.integer(V_Feedback),
    Rating             = as.numeric(Rating),
    `Rating Count`     = as.numeric(`Rating Count`),
    `Maximum Installs` = as.numeric(`Maximum Installs`),
    Price          = as.numeric(Price),
    LogMaxInstalls = as.numeric(LogMaxInstalls),
    IAP_bin = ifelse(tolower(as.character(`In App Purchases`)) == "true", 1L, 0L),
    ADS_bin = ifelse(tolower(as.character(`Ad Supported`))     == "true", 1L, 0L)
  )

# Conservative imputation (missing = absence of mechanic = 0)
apps$V_Ranking[is.na(apps$V_Ranking)]         <- 0L
apps$V_Recompensas[is.na(apps$V_Recompensas)] <- 0L

# Bayesian shrinkage estimator for perceived quality (Rating_Adj)
vi <- apps$`Rating Count`
Ri <- apps$Rating
C  <- mean(Ri, na.rm = TRUE)
m0 <- quantile(vi, 0.75, na.rm = TRUE)
apps$Rating_Adj <- (vi / (vi + m0)) * Ri + (m0 / (vi + m0)) * C

# Composite gamification index (IGam)
apps$IGam <- apps$V_Niveles + apps$V_Recompensas +
             apps$V_Ranking + apps$V_Avatares + apps$V_Feedback

# Sanity check on the regularization threshold m0
cat("m0 =", m0, "\n")
cat("% apps with fewer than m0 ratings:",
    round(mean(apps$`Rating Count` < m0, na.rm = TRUE) * 100, 1), "%\n")
