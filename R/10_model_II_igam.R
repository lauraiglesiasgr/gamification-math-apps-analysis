# 10_model_II_igam.R - Model II (composite IGam) + Model I vs II F-test.
library(car); library(sandwich); library(lmtest)

model_II <- lm(LogMaxInstalls ~
                 IGam + Price + Rating_Adj + ADS_bin + IAP_bin,
               data = apps)
summary(model_II)

cat("Adjusted R2 Model I :", round(summary(model_I)$adj.r.squared, 4), "\n")
cat("Adjusted R2 Model II:", round(summary(model_II)$adj.r.squared, 4), "\n")

# Robust (HC3) F-test of linear restrictions: do the five individual
# mechanics carry more information than the aggregated IGam index?
linearHypothesis(model_I,
  c("V_Niveles = V_Recompensas",
    "V_Niveles = V_Ranking",
    "V_Niveles = V_Avatares",
    "V_Niveles = V_Feedback"),
  vcov = vcovHC(model_I, type = "HC3"))
