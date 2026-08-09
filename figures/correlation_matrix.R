# =============================================================================
# figures/correlation_matrix.R
# Pearson correlation matrix (upper triangle) of the model variables.
# Values are those reported in Figure 4.2 (n = 200). Self-contained so the
# figure regenerates without the raw sample; to compute from data instead,
# use cor() on the analytic sample (see R/08_correlation_matrix.R).
# Run from repo root:  source("figures/correlation_matrix.R")
# Output: figures/correlation_matrix.png
# =============================================================================

library(ggplot2)

labels <- c("Downloads","Levels","Rewards","Ranking","Avatars",
            "Feedback","Price","Adj. rating","Advertising","IAP")
N <- length(labels)

# upper-triangle values (row by row, including diagonal) from Fig 4.2
rows <- list(
  c(1.00,0.11,0.24,0.14,0.14,-0.03,0.06,-0.35,0.17,0.29),
  c(1.00,0.53,0.42,0.36,0.56,0.04,0.00,-0.02,0.24),
  c(1.00,0.35,0.51,0.31,-0.04,-0.01,-0.07,0.26),
  c(1.00,0.45,0.24,-0.03,-0.11,-0.07,0.08),
  c(1.00,0.21,-0.03,-0.14,-0.03,0.19),
  c(1.00,0.03,0.03,-0.03,0.21),
  c(1.00,0.00,-0.16,-0.05),
  c(1.00,0.00,-0.20),
  c(1.00,-0.04),
  c(1.00)
)
M <- matrix(NA_real_, N, N)
for (i in seq_len(N)) for (k in seq_along(rows[[i]])) {
  M[i, i + k - 1] <- rows[[i]][k]; M[i + k - 1, i] <- rows[[i]][k]
}

# long data frame, upper triangle only, diagonal dropped
df <- expand.grid(row = 1:N, col = 1:N)
df$r <- mapply(function(i, j) M[i, j], df$row, df$col)
df <- df[df$col > df$row, ]           # strictly upper triangle
df$lab <- sub("^(-?)0\\.", "\\1.", sprintf("%.2f", df$r))  # .24 / -.35
df$txtcol <- ifelse(abs(df$r) >= 0.33, "white", "#1f2430")

df$rowf <- factor(labels[df$row], levels = labels)
df$colf <- factor(labels[df$col], levels = labels)

p <- ggplot(df, aes(colf, rowf, fill = r)) +
  geom_tile(colour = "white", linewidth = 1.4) +
  geom_text(aes(label = lab, colour = txtcol,
                fontface = ifelse(abs(r) >= 0.30, "bold", "plain")),
            size = 3.7, show.legend = FALSE) +
  scale_colour_identity() +
  scale_fill_gradient2(low = "#c0392b", mid = "#ffffff", high = "#0f766e",
                       midpoint = 0, limits = c(-0.6, 0.6),
                       name = "Pearson r", oob = scales::squish) +
  scale_x_discrete(position = "top") +
  scale_y_discrete(limits = rev(labels)) +
  coord_fixed() +
  labs(
    title    = "How the variables move together",
    subtitle = "Pearson correlations · n = 200 · teal = positive, red = negative · max |r| = 0.56",
    x = NULL, y = NULL,
    caption  = "Laura Iglesias García · 2026 · Bachelor's thesis, URJC"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title    = element_text(face = "bold", size = 16.5),
    plot.subtitle = element_text(colour = "#6b7280", size = 10.5, margin = margin(b = 8)),
    plot.caption  = element_text(colour = "#9aa0a6", size = 8.5, hjust = 1),
    axis.text.x   = element_text(angle = 45, hjust = 0, colour = "#1f2430"),
    axis.text.y   = element_text(colour = "#1f2430"),
    panel.grid    = element_blank(),
    legend.position = "bottom",
    legend.key.width = unit(2.2, "cm"),
    legend.key.height = unit(0.35, "cm")
  )

ggsave("figures/correlation_matrix.png", p,
       width = 9.2, height = 9.2, dpi = 150, bg = "white")
message("Saved figures/correlation_matrix.png")
