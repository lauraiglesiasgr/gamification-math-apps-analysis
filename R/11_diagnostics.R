# 11_diagnostics.R - VIF, heteroscedasticity, normality, influential obs.
library(car); library(lmtest)

# Multicollinearity (VIF)
vif_vals <- vif(model_I); print(round(vif_vals, 3))

# Heteroscedasticity (Breusch-Pagan)
print(bptest(model_I))

# Residual normality (Shapiro-Wilk)
print(shapiro.test(residuals(model_I)))

# Q-Q plot of standardized residuals
pdf("figures/qq_residuals.pdf", width = 6, height = 6)
qqnorm(rstandard(model_I),
       main = "Q-Q Plot - Standardized Residuals (Model I)",
       xlab = "Theoretical Quantiles", ylab = "Sample Quantiles",
       pch = 16, col = "steelblue", cex = 0.7)
qqline(rstandard(model_I), col = "red", lwd = 1.5)
dev.off()

# Cook's distance (influential observations)
cook      <- cooks.distance(model_I)
threshold <- 4 / nrow(apps)
cat("Influential observations:", sum(cook > threshold), "\n")

pdf("figures/cooks_distance.pdf", width = 9, height = 5)
plot(cook, type = "h",
     col = ifelse(cook > threshold, "red", "steelblue"),
     main = "Cook's Distance by Observation",
     xlab = "Observation Index", ylab = "Cook's Distance", lwd = 1.5)
abline(h = threshold, col = "red", lty = 2, lwd = 1.5)
legend("topright",
       legend = c("Normal", "Influential", "Threshold 4/n"),
       col = c("steelblue","red","red"), lty = c(1,1,2), lwd = 1.5)
dev.off()
