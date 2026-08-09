# 09_model_I_ols_hc3.R - Model I: OLS with HC3 robust standard errors.
library(sandwich); library(lmtest)

model_I <- lm(LogMaxInstalls ~
                V_Niveles + V_Recompensas + V_Ranking +
                V_Avatares + V_Feedback +
                Price + Rating_Adj + ADS_bin + IAP_bin,
              data = apps)
summary(model_I)

# HC3 robust standard errors (heteroscedasticity-consistent)
coeftest(model_I, vcov = vcovHC(model_I, type = "HC3"))
