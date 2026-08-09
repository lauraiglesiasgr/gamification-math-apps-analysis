# 08_correlation_matrix.R - Pearson correlation matrix.
library(corrplot)

cor_vars <- c("LogMaxInstalls","V_Niveles","V_Recompensas",
              "V_Ranking","V_Avatares","V_Feedback",
              "Price","Rating_Adj","ADS_bin","IAP_bin")

cor_mat <- cor(apps[, cor_vars], use = "complete.obs", method = "pearson")

pdf("figures/correlation_matrix.pdf", width = 9, height = 8)
corrplot(cor_mat, method = "color", type = "upper",
         addCoef.col = "black", number.cex = 0.7,
         tl.col = "black", tl.srt = 45,
         title = "Pearson Correlation Matrix", mar = c(0,0,2,0))
dev.off()
