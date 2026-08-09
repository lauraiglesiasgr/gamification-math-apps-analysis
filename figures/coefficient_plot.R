# =============================================================================
# figures/coefficient_plot.R
# Hero figure: coefficient (forest) plot for OLS Model I.
# Estimates & 95% CIs are the HC3-robust results reported in Table 4.7
# (produced by R/09_model_I_ols_hc3.R). Hardcoded here so the figure is
# self-contained and always matches the reported table.
#
# Run from the repo root:  source("figures/coefficient_plot.R")
# Output: figures/coefficient_plot.png
# =============================================================================

library(ggplot2)

coefs <- data.frame(
  term  = c("Rewards","Ranking","Levels","Feedback","Avatars",
            "In-app purchases","Advertising","Price","Adjusted rating"),
  group = c(rep("Gamification mechanics", 5),
            rep("Controls · monetization & quality", 4)),
  beta  = c( 0.986, 0.445, -0.006, -0.343, -0.436,
             0.736, 0.501,  0.438, -1.846),
  lo    = c( 0.27, -0.63, -0.47, -0.65, -1.29,
             0.23,  0.21,  0.00, -2.55),
  hi    = c( 1.71,  1.52,  0.46, -0.03,  0.41,
             1.24,  0.79,  0.88, -1.15),
  p     = c(0.008, 0.417, 0.979, 0.030, 0.315,
            0.005, 0.001, 0.052, 0.0001),
  stars = c("**","","","*","", "**","***","","***"),
  stringsAsFactors = FALSE
)

# significance category drives colour
coefs$sig <- with(coefs, ifelse(p >= 0.05, "Not significant",
                         ifelse(beta > 0, "Positive · significant",
                                          "Negative · significant")))
coefs$sig <- factor(coefs$sig,
  levels = c("Positive · significant","Negative · significant","Not significant"))
coefs$group <- factor(coefs$group,
  levels = c("Gamification mechanics","Controls · monetization & quality"))

# order rows by beta within each facet
coefs <- coefs[order(coefs$group, coefs$beta), ]
coefs$term <- factor(coefs$term, levels = coefs$term[!duplicated(coefs$term)])

pal <- c("Positive · significant" = "#0f766e",
         "Negative · significant" = "#c0392b",
         "Not significant"        = "#9aa0a6")

lab_x <- 2.35   # right-margin numeric column

p <- ggplot(coefs, aes(beta, term, colour = sig)) +
  geom_vline(xintercept = 0, linetype = "22", colour = "#c3c8d0", linewidth = 0.6) +
  geom_errorbarh(aes(xmin = lo, xmax = hi), height = 0.22, linewidth = 1.0) +
  geom_point(size = 4, fill = "white", stroke = 1.1, shape = 21) +
  geom_text(aes(x = lab_x,
                label = ifelse(stars == "",
                               sprintf("%+.2f", beta),
                               sprintf("%+.2f%s", beta, stars)),
                fontface = ifelse(p < 0.05, "bold", "plain")),
            hjust = 1, size = 3.8, show.legend = FALSE) +
  facet_grid(rows = vars(group), scales = "free_y", space = "free_y", switch = "y") +
  scale_colour_manual(values = pal, name = NULL) +
  scale_x_continuous(limits = c(-2.85, 2.45),
                     breaks = c(-2,-1,0,1,2)) +
  labs(
    title    = "What actually predicts downloads of educational math apps?",
    subtitle = "OLS regression · n = 200 apps · adj. R² = 0.25 · points right of the dashed line = more downloads",
    x = expression("Association with downloads · " * beta * " on log"[10] * "(downloads), HC3 robust 95% CI"),
    y = NULL,
    caption  = "Laura Iglesias García · 2026 · Bachelor's thesis, URJC   |   * p<.05  ** p<.01  *** p<.001"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    legend.position   = "top",
    legend.justification = "left",
    plot.title        = element_text(face = "bold", size = 16),
    plot.subtitle     = element_text(colour = "#6b7280", size = 10.5,
                                     margin = margin(b = 8)),
    plot.caption      = element_text(colour = "#9aa0a6", size = 8.5, hjust = 0),
    strip.text.y.left = element_text(face = "bold", colour = "#4b5563",
                                     angle = 0, hjust = 0),
    strip.placement   = "outside",
    panel.grid.major.y = element_blank(),
    panel.grid.minor   = element_blank(),
    panel.grid.major.x = element_line(colour = "#eef0f3"),
    axis.text.y       = element_text(colour = "#1f2430", size = 12),
    axis.ticks        = element_blank(),
    plot.margin       = margin(12, 16, 10, 12)
  )

ggsave("figures/coefficient_plot.png", p,
       width = 11.5, height = 7.2, dpi = 150, bg = "white")
message("Saved figures/coefficient_plot.png")
