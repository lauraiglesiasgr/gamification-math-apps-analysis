# =============================================================================
# figures/igam_distribution.R
# Distribution of the composite gamification index (IGam).
# Frequencies are those reported in Table 4.6 / Figure 4.1 (n = 200).
# Run from repo root:  source("figures/igam_distribution.R")
# Output: figures/igam_distribution.png
# =============================================================================

library(ggplot2)

d <- data.frame(
  igam = factor(0:5),
  freq = c(94, 53, 27, 16, 6, 4),
  pct  = c(47.0, 26.5, 13.5, 8.0, 3.0, 2.0)
)
d$label <- sprintf("%d\n(%.0f%%)", d$freq, d$pct)
shades <- c("#8fb7b3","#5c9c96","#2f8880","#0f766e","#0b5c55","#08433e")

p <- ggplot(d, aes(igam, freq, fill = igam)) +
  geom_col(width = 0.72, show.legend = FALSE) +
  geom_text(aes(label = label), vjust = -0.25, size = 3.8,
            fontface = "bold", colour = "#1f2430", lineheight = 0.9) +
  annotate("text", x = 1.9, y = 100, label = "47% implement\nno gamification at all",
           colour = "#0f766e", fontface = "bold", hjust = 0, size = 3.6) +
  annotate("curve", x = 1.85, y = 99, xend = 1.15, yend = 95,
           colour = "#0f766e", curvature = 0.2,
           arrow = arrow(length = unit(0.02, "npc"))) +
  scale_fill_manual(values = shades) +
  scale_y_continuous(limits = c(0, 108), expand = c(0, 0)) +
  labs(
    title    = "Full gamification is the exception, not the norm",
    subtitle = "Distribution of the gamification index across 200 educational math apps",
    x = "Gamification index (IGam) — number of the 5 mechanics an app implements",
    y = "Number of apps",
    caption  = "Laura Iglesias García · 2026 · Bachelor's thesis, URJC"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title    = element_text(face = "bold", size = 16.5),
    plot.subtitle = element_text(colour = "#6b7280", size = 11, margin = margin(b = 10)),
    plot.caption  = element_text(colour = "#9aa0a6", size = 8.5, hjust = 1),
    panel.grid.major.x = element_blank(),
    panel.grid.minor   = element_blank(),
    panel.grid.major.y = element_line(colour = "#eef0f3"),
    axis.ticks = element_blank(),
    plot.margin = margin(14, 16, 10, 12)
  )

ggsave("figures/igam_distribution.png", p,
       width = 9.6, height = 6.0, dpi = 150, bg = "white")
message("Saved figures/igam_distribution.png")
