

continuous_vars <- c(
  "mk6240.sig", "mk6240.mean", "age", "hip.ipsi", "hip.cntr", "EpiTrack", "Episodic",
  "Semantic", "onset", "duration", "GTCSF", "IEDs", "asm.number",
  "ipsi.thalamus", "ipsi.caudate", "ipsi.putamen", "ipsi.pallidus",
  "ipsi.hippocampus", "ipsi.amygdala", "ipsi.accumbens",
  "cntr.thalamus", "cntr.caudate", "cntr.putamen", "cntr.pallidus",
  "cntr.hippocampus", "cntr.amygdala", "cntr.accumbens",
  "fc.strength", "fc.clustecoef", "fc.efficiency", "fc.pathlengh", "fc.neighbors",
  "sc.strength", "sc.clustecoef", "sc.efficiency", "sc.pathlengh", "sc.neighbors"
)

categorical_vars <- c("sex", "hs", "dre")

cohen_d <- function(a, b) {
  na <- length(na.omit(a)); nb <- length(na.omit(b))
  pooled_sd <- sqrt(((na - 1) * stats::var(a, na.rm = TRUE) + (nb - 1) * stats::var(b, na.rm = TRUE)) / (na + nb - 2))
  (mean(b, na.rm = TRUE) - mean(a, na.rm = TRUE)) / pooled_sd
}


# ------------------------------------------------------
# Patients ONLY Top 25 vs rest of patients
df_sub <- mk.df %>%
  filter(group == "Patient", mk6240.session == 1) %>%
  mutate(mk6240.per = droplevels(factor(mk6240.per))) %>%
  dplyr::select(
    mk6240.sig, mk6240.mean, sex, age, hip.ipsi, hip.cntr, EpiTrack, Episodic, Semantic,
    onset, duration, hs, GTCSF, IEDs, asm.number, dre,
    ipsi.thalamus, ipsi.caudate, ipsi.putamen, ipsi.pallidus,
    ipsi.hippocampus, ipsi.amygdala, ipsi.accumbens,
    cntr.thalamus, cntr.caudate, cntr.putamen, cntr.pallidus,
    cntr.hippocampus, cntr.amygdala, cntr.accumbens,
    fc.strength, fc.clustecoef, fc.efficiency, fc.pathlengh, fc.neighbors,
    sc.strength, sc.clustecoef, sc.efficiency, sc.pathlengh, sc.neighbors,
    mk6240.per
  )

cont_rows <- lapply(continuous_vars, function(v) {
  g1 <- df_sub %>% filter(mk6240.per == "rest") %>% pull(!!sym(v))
  g2 <- df_sub %>% filter(mk6240.per == "t25")  %>% pull(!!sym(v))
  data.frame(
    Demographics = v,
    rest         = sprintf("%.2f±%.2f", mean(g1, na.rm = TRUE), sd(g1, na.rm = TRUE)),
    t25          = sprintf("%.2f±%.2f", mean(g2, na.rm = TRUE), sd(g2, na.rm = TRUE)),
    `Cohen's D`  = cohen_d(g1, g2),
    check.names  = FALSE
  )
}) %>% bind_rows()

cat_rows <- lapply(categorical_vars, function(v) {
  tbl <- table(df_sub[[v]], df_sub$mk6240.per)
  lvl <- if (v == "sex") "F" else rownames(tbl)[2]
  p1  <- tbl[lvl, "rest"] / sum(tbl[, "rest"])
  p2  <- tbl[lvl, "t25"]  / sum(tbl[, "t25"])
  h   <- 2 * asin(sqrt(p2)) - 2 * asin(sqrt(p1))
  data.frame(
    Demographics = sprintf("%s: %s", v, lvl),
    rest         = sprintf("%d (%.2f%%)", tbl[lvl, "rest"], p1 * 100),
    t25          = sprintf("%d (%.2f%%)", tbl[lvl, "t25"],  p2 * 100),
    `Cohen's D`  = h,
    check.names  = FALSE
  )
}) %>% bind_rows()

# store combined df for reuse in both table and plot
combined <- bind_rows(cont_rows, cat_rows) %>%
  arrange(desc(`Cohen's D`))

# ------------------------------------------------------
# # Patients Top 25 vs Healthy
# df_sub <- mk.df %>%
#   filter(
#     (group == "Healthy" & mk6240.per == "rest") |
#       (group == "Patient" & mk6240.per == "t25")
#   ) %>%
#   mutate(group = droplevels(factor(group))) %>%
#   dplyr::select(
#     mk6240.sig, mk6240.mean, sex, age, hip.ipsi, hip.cntr, EpiTrack, Episodic, Semantic,
#     ipsi.thalamus, ipsi.caudate, ipsi.putamen, ipsi.pallidus,
#     ipsi.hippocampus, ipsi.amygdala, ipsi.accumbens,
#     cntr.thalamus, cntr.caudate, cntr.putamen, cntr.pallidus,
#     cntr.hippocampus, cntr.amygdala, cntr.accumbens,
#     fc.strength, fc.clustecoef, fc.efficiency, fc.pathlengh, fc.neighbors,
#     sc.strength, sc.clustecoef, sc.efficiency, sc.pathlengh, sc.neighbors,
#     group
#   )
# 
# continuous_vars <- c(
#   "mk6240.sig", "mk6240.mean", "age", "hip.ipsi", "hip.cntr", "EpiTrack", "Episodic", "Semantic", 
#   "ipsi.thalamus", "ipsi.caudate", "ipsi.putamen", "ipsi.pallidus",
#   "ipsi.hippocampus", "ipsi.amygdala", "ipsi.accumbens",
#   "cntr.thalamus", "cntr.caudate", "cntr.putamen", "cntr.pallidus",
#   "cntr.hippocampus", "cntr.amygdala", "cntr.accumbens",
#   "fc.strength", "fc.clustecoef", "fc.efficiency", "fc.pathlengh", "fc.neighbors",
#   "sc.strength", "sc.clustecoef", "sc.efficiency", "sc.pathlengh", "sc.neighbors"
# )
# 
# categorical_vars <- c("sex")
# 
# cont_rows <- lapply(continuous_vars, function(v) {
#   g1 <- df_sub %>% filter(group == "Healthy") %>% pull(!!sym(v))
#   g2 <- df_sub %>% filter(group == "Patient") %>% pull(!!sym(v))
#   data.frame(
#     Demographics = v,
#     Healthy      = sprintf("%.1f±%.1f", mean(g1, na.rm = TRUE), sd(g1, na.rm = TRUE)),
#     Patient      = sprintf("%.1f±%.1f", mean(g2, na.rm = TRUE), sd(g2, na.rm = TRUE)),
#     `Cohen's D`  = cohen_d(g1, g2),
#     check.names  = FALSE
#   )
# }) %>% bind_rows()
# 
# cat_rows <- lapply(categorical_vars, function(v) {
#   tbl <- table(df_sub[[v]], df_sub$group)
#   lvl <- if (v == "sex") "F" else rownames(tbl)[2]
#   p1  <- tbl[lvl, "Healthy"] / sum(tbl[, "Healthy"])
#   p2  <- tbl[lvl, "Patient"] / sum(tbl[, "Patient"])
#   h   <- 2 * asin(sqrt(p2)) - 2 * asin(sqrt(p1))
#   data.frame(
#     Demographics = sprintf("%s: %s", v, lvl),
#     Healthy      = sprintf("%d (%.1f%%)", tbl[lvl, "Healthy"], p1 * 100),
#     Patient      = sprintf("%d (%.1f%%)", tbl[lvl, "Patient"], p2 * 100),
#     `Cohen's D`  = h,
#     check.names  = FALSE
#   )
# }) %>% bind_rows()
# 
# combined <- bind_rows(cont_rows, cat_rows) %>%
#   arrange(desc(`Cohen's D`))


# ------------------------------------------------------
# Table D values
combined %>%
  mutate(`Cohen's D` = sprintf("%.2f", `Cohen's D`)) %>%
  kable(
    booktabs = TRUE,
    longtable = TRUE,
    linesep = "",
    align = c("l", "c", "c", "c")
  ) %>%
  kable_styling(
    position = "left",
    latex_options = c("striped", "repeat_header"),
    stripe_color = "gray!15"
  )

# ------------------------------------------------------
# Barplot with sorted cohen's D values
combined %>%
  ggplot(aes(x = `Cohen's D`, y = reorder(Demographics, `Cohen's D`), fill = `Cohen's D`)) +
  geom_col() +
  geom_vline(xintercept = 0, linewidth = 0.5, color = "black") +
  geom_vline(xintercept = c(-0.8, -0.5, 0.5, 0.8),
             linewidth = 0.3, color = "grey40", linetype = "dashed") +
  scale_fill_distiller(
    palette = "RdBu",
    limits  = c(-2, 2),
    oob     = scales::squish,
    name    = "Cohen's D"
  ) +
  labs(x = "Effect size", y = NULL) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor   = element_blank(),
    legend.position    = "bottom",
    legend.key.width   = unit(2, "cm")
  )

# ------------------------------------------------------
# Barplot with sorted cohen's D values, filtered for abs(D) > 0.5
combined %>%
  filter(abs(`Cohen's D`) > 0.5) %>%
  ggplot(aes(x = `Cohen's D`, y = reorder(Demographics, `Cohen's D`), fill = `Cohen's D`)) +
  geom_col() +
  geom_vline(xintercept = 0, linewidth = 0.5, color = "black") +
  geom_vline(xintercept = c(-0.8, -0.5, 0.5, 0.8),
             linewidth = 0.3, color = "grey40", linetype = "dashed") +
  scale_fill_distiller(
    palette = "RdBu",
    limits  = c(-2, 2),
    oob     = scales::squish,
    name    = "Cohen's D"
  ) +
  labs(x = "Effect size", y = NULL) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor   = element_blank(),
    legend.position    = "bottom",
    legend.key.width   = unit(2, "cm")
  )
