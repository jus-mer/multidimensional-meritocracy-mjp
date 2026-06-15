# 0. Identification ---------------------------------------------------

# Title: LCA for Merit-scale code of EDUMERCO data
# Institution: JUSMER
# Responsible: Andreas Laffert

# Executive Summary: This script contains the code for run an LCA for merit scale in EDUMERCO data
# Date: March 5, 2026

# 1. Packages  -----------------------------------------------------

if (! require("pacman")) install.packages("pacman")

pacman::p_load(tidyverse,
               sjmisc, 
               here,
               lavaan,
               psych,
               corrplot,
               ggdist,
               sjlabelled,
               patchwork,
               RColorBrewer,
               semTools,
               rlang,
               summarytools)

options(scipen=999)
rm(list = ls())
# 2. Data -----------------------------------------------------------------

load(url("https://github.com/jus-mer/lca-merit-pensions/raw/refs/heads/main/input/data/proc/db_proc.RData"))

glimpse(db)

## Analytical sample

db <- db %>% 
  mutate(

    income = factor(income, levels = c(
      "Menos de $280.000 mensuales liquidos",
      "De $280.001 a $380.000 mensuales liquidos",
      "De $380.001 a $470.000 mensuales liquidos",
      "De $470.001 a $610.000 mensuales liquidos",
      "De $610.001 a $730.000 mensuales liquidos",
      "De $730.001 a $890.000 mensuales liquidos",
      "De $890.001 a $1.100.000 mensuales liquidos",
      "De $1.100.001 a $2.700.000 mensuales liquidos",
      "De $2.700.001 a $4.100.000 mensuales liquidos",
      "Mas de $4.100.001 mensuales liquidos"
    )),
    income_5 = case_when(
      income %in% c(
        "Menos de $280.000 mensuales liquidos",
        "De $280.001 a $380.000 mensuales liquidos"
      ) ~ "Q1",
      income %in% c(
        "De $380.001 a $470.000 mensuales liquidos",
        "De $470.001 a $610.000 mensuales liquidos"
      ) ~ "Q2",
      income %in% c(
        "De $610.001 a $730.000 mensuales liquidos",
        "De $730.001 a $890.000 mensuales liquidos"
      ) ~ "Q3",
      income %in% c(
        "De $890.001 a $1.100.000 mensuales liquidos",
        "De $1.100.001 a $2.700.000 mensuales liquidos"
      ) ~ "Q4",
      income %in% c(
        "De $2.700.001 a $4.100.000 mensuales liquidos",
        "Mas de $4.100.001 mensuales liquidos"
      ) ~ "Q5",
      TRUE ~ NA_character_
    ),
    income_5 = factor(income_5, levels = c("Q1", "Q2", "Q3", "Q4", "Q5"))
  )


frq(db$income)
frq(db$income_5)

db$sex <- if_else(db$sex == 1, "Male", "Female")
db$sex <- factor(db$sex, levels = c("Male", "Female"))

db <- db %>% 
  dplyr::select(-income)

db_or <- db

#db <- db %>% 
#  dplyr::select(-c(just_educ, just_healthcare)) %>% 
#  na.omit()

# 3. Analysis -------------------------------------------------------------

# 3.1 descriptive ----
vars_m <- c("perc_effort",
            "perc_talent",
            "perc_rich_parents",
            "perc_contact",
            "pref_effort",
            "pref_talent",
            "pref_rich_parents",
            "pref_contact")

t1 <- db %>% 
  dplyr::select(all_of(vars_m), ends_with("_d"))


df<-dfSummary(t1,
              plain.ascii = FALSE,
              style = "multiline",
              tmp.img.dir = "/tmp",
              graph.magnif = 0.75,
              headings = F,  # encabezado
              varnumbers = F, # num variable
              labels.col = T, # etiquetas
              na.col = T,    # missing
              graph.col = T, # plot
              valid.col = T, # n valido
              col.widths = c(20,10,10,10,10,10))

df$Variable <- NULL # delete variable column

print(df, method="render")

db <- db %>% 
  mutate(
    across(
      .cols = all_of(vars_m),
      .fns = ~as.numeric(.)
    ))

labels1 <- c("Strongly desagree" = 1, 
             "Desagree" = 2, 
             "Agree" = 3, 
             "Strongly agree" = 4)
db <- db %>% 
  mutate(
    across(
      .cols = all_of(vars_m),
      .fns = ~  sjlabelled::set_labels(., labels = labels1)
    )
  )

df <- db %>% 
  dplyr::select(all_of(vars_m)) %>% 
  drop_na()

theme_set(theme_ggdist())
colors <- RColorBrewer::brewer.pal(n = 4, name = "RdBu")


a <- df %>% 
  dplyr::select(perc_effort, 
                perc_talent,
                perc_rich_parents,
                perc_contact) %>% 
  sjPlot::plot_likert(geom.colors = colors,
                      title = c("a. Perceptions"),
                      geom.size = 0.8,
                      axis.labels = c("Effort", "Talent", "Rich parents", "Contacts"),
                      catcount = 4,
                      values  =  "sum.outside",
                      reverse.colors = F,
                      reverse.scale = T,
                      show.n = FALSE,
                      show.prc.sign = T
  ) +
  ggplot2::theme(legend.position = "none",
                 text = element_text(size = 16))

b <- df %>% 
  dplyr::select(pref_effort, 
                pref_talent,
                pref_rich_parents,
                pref_contact) %>% 
  sjPlot::plot_likert(geom.colors = colors,
                      title = c("b. Preferences"),
                      geom.size = 0.8,
                      axis.labels = c("Effort", "Talent", "Rich parents", "Contacts"),
                      catcount = 4,
                      values  =  "sum.outside",
                      reverse.colors = F,
                      reverse.scale = T,
                      show.n = FALSE,
                      show.prc.sign = T
  ) +
  ggplot2::theme(legend.position = "bottom",
                 text = element_text(size = 16))

likerplot <- a / b + plot_annotation(caption = paste0("Source: own elaboration based on Survey EDUMERCO"," (n = ",dim(df)[1],")"
))

likerplot

# 3.2 correlations ----

M <- df %>% 
  psych::polychoric()

diag(M$rho) <- NA

rownames(M$rho) <- c("A. Perception Effort",
                     "B. Perception Talent",
                     "C. Perception Rich parents",
                     "D. Perception Contacts",
                     "E. Preference Effort",
                     "F. Preference Talent",
                     "G. Preference Rich parents",
                     "H. Preference Contacts")

#set Column names of the matrix
colnames(M$rho) <-c("(A)", "(B)","(C)","(D)","(E)","(F)","(G)",
                    "(H)")

testp <- cor.mtest(M$rho, conf.level = 0.95)

#Plot the matrix using corrplot
corrplot::corrplot(M$rho,
                   method = "color",
                   addCoef.col = "black",
                   type = "upper",
                   tl.col = "black",
                   col = colorRampPalette(c("#E16462", "white", "#0D0887"))(12),
                   bg = "white",
                   na.label = "-") 

# 3.3 CFA: ----
#### CFA All countries #### 

model_base <- ('
perc_merit =~ perc_effort + perc_talent
perc_nmerit =~ perc_rich_parents + perc_contact
pref_merit =~ pref_effort + pref_talent
pref_nmerit =~ pref_rich_parents + pref_contact
')

# Estimación 
db %>% 
  dplyr::select(all_of(vars_m)) %>% 
  mardia(na.rm = TRUE, plot=TRUE)

fit_cfa <<- cfa(model = model_base, 
                data = db, 
                estimator = "WLSMV",
                ordered = T,
                std.lv = F,
                parameterization = "theta")

summary(fit_cfa, fit.measures = TRUE, standardized = TRUE, rsquare = TRUE)

fitmeasures(fit_cfa, c("chisq", "pvalue", "df", "cfi", "tli", "rmsea", "rmsea.ci.lower", "rmsea.ci.upper", "srmr"))

# 3.4 SEM pensions ----

db_sem <- db %>% 
  dplyr::select(just_pension, all_of(vars_m), age, sex, educ, income_5, pol) |> 
  na.omit()

db_sem$just_pension <- as.numeric(db_sem$just_pension)

db_sem <- db_sem %>% 
  mutate(
    across(
      .cols = all_of(vars_m),
      .fns = ~as.numeric(.)
    ))

# asegurar referencias
db_sem$income_5 <- relevel(db_sem$income_5, ref = "Q1")
db_sem$pol <- relevel(db_sem$pol, ref = "Left")

# crear dummies
X_income <- model.matrix(~ income_5, data = db_sem)[, -1, drop = FALSE]
X_pol    <- model.matrix(~ pol, data = db_sem)[, -1, drop = FALSE]

# unir
db_sem <- cbind(db_sem, as.data.frame(X_income), as.data.frame(X_pol))

# limpiar nombres
names(db_sem) <- make.names(names(db_sem))

db_sem$sex_female <- ifelse(db_sem$sex == "Female", 1, 0)

model <- c('
  perc_merit =~ perc_effort + perc_talent
  perc_nmerit =~ perc_rich_parents + perc_contact
  pref_merit =~ pref_effort + pref_talent
  pref_nmerit =~ pref_rich_parents + pref_contact

  just_pension ~ perc_merit + perc_nmerit + pref_merit + pref_nmerit +
                 age + educ + sex_female +
                 income_5Q2 + income_5Q3 + income_5Q4 + income_5Q5 +
                 polCenter + polRight + polDoes.not.identify
')

ord_vars <- c(
  "just_pension",
  "perc_effort", "perc_talent",
  "perc_rich_parents", "perc_contact",
  "pref_effort", "pref_talent",
  "pref_rich_parents", "pref_contact"
)

fit_sem <- lavaan::sem(
  model,
  data = db_sem,
  estimator = "WLSMV",
  ordered = ord_vars
)

summary(fit_sem, fit.measures = TRUE, standardized = TRUE, rsquare = TRUE)

fitmeasures(fit_sem, c("chisq", "pvalue", "df", "cfi", "tli", "rmsea", "rmsea.ci.lower", "rmsea.ci.upper", "srmr"))


# 3.4 SEM educ ----

db_sem2 <- db %>% 
  dplyr::select(just_educ, all_of(vars_m), age, sex, educ, income_5, pol) |> 
  na.omit()

db_sem2$just_educ <- as.numeric(db_sem2$just_educ)

db_sem2 <- db_sem2 %>% 
  mutate(
    across(
      .cols = all_of(vars_m),
      .fns = ~as.numeric(.)
    ))

# asegurar referencias
db_sem2$income_5 <- relevel(db_sem2$income_5, ref = "Q1")
db_sem2$pol <- relevel(db_sem2$pol, ref = "Left")

# crear dummies
X_income <- model.matrix(~ income_5, data = db_sem2)[, -1, drop = FALSE]
X_pol    <- model.matrix(~ pol, data = db_sem2)[, -1, drop = FALSE]

# unir
db_sem2 <- cbind(db_sem2, as.data.frame(X_income), as.data.frame(X_pol))

# limpiar nombres
names(db_sem2) <- make.names(names(db_sem2))

db_sem2$sex_female <- ifelse(db_sem2$sex == "Female", 1, 0)

model <- c('
  perc_merit =~ perc_effort + perc_talent
  perc_nmerit =~ perc_rich_parents + perc_contact
  pref_merit =~ pref_effort + pref_talent
  pref_nmerit =~ pref_rich_parents + pref_contact

  just_educ ~ perc_merit + perc_nmerit + pref_merit + pref_nmerit +
                 age + educ + sex_female +
                 income_5Q2 + income_5Q3 + income_5Q4 + income_5Q5 +
                 polCenter + polRight + polDoes.not.identify
')

ord_vars <- c(
  "just_educ",
  "perc_effort", "perc_talent",
  "perc_rich_parents", "perc_contact",
  "pref_effort", "pref_talent",
  "pref_rich_parents", "pref_contact"
)

fit_sem2 <- lavaan::sem(
  model,
  data = db_sem2,
  estimator = "WLSMV",
  ordered = ord_vars
)

summary(fit_sem2, fit.measures = TRUE, standardized = TRUE, rsquare = TRUE)

fitmeasures(fit_sem2, c("chisq", "pvalue", "df", "cfi", "tli", "rmsea", "rmsea.ci.lower", "rmsea.ci.upper", "srmr"))

# 3.4 SEM healthcare ----

db_sem3 <- db %>% 
  dplyr::select(just_healthcare, all_of(vars_m), age, sex, educ, income_5, pol) |> 
  na.omit()

db_sem3$just_healthcare <- as.numeric(db_sem3$just_healthcare)

db_sem3 <- db_sem3 %>% 
  mutate(
    across(
      .cols = all_of(vars_m),
      .fns = ~as.numeric(.)
    ))

# asegurar referencias
db_sem3$income_5 <- relevel(db_sem3$income_5, ref = "Q1")
db_sem3$pol <- relevel(db_sem3$pol, ref = "Left")

# crear dummies
X_income <- model.matrix(~ income_5, data = db_sem3)[, -1, drop = FALSE]
X_pol    <- model.matrix(~ pol, data = db_sem3)[, -1, drop = FALSE]

# unir
db_sem3 <- cbind(db_sem3, as.data.frame(X_income), as.data.frame(X_pol))

# limpiar nombres
names(db_sem3) <- make.names(names(db_sem3))

db_sem3$sex_female <- ifelse(db_sem3$sex == "Female", 1, 0)

model <- c('
  perc_merit =~ perc_effort + perc_talent
  perc_nmerit =~ perc_rich_parents + perc_contact
  pref_merit =~ pref_effort + pref_talent
  pref_nmerit =~ pref_rich_parents + pref_contact

  just_healthcare ~ perc_merit + perc_nmerit + pref_merit + pref_nmerit +
                 age + educ + sex_female +
                 income_5Q2 + income_5Q3 + income_5Q4 + income_5Q5 +
                 polCenter + polRight + polDoes.not.identify
')

ord_vars <- c(
  "just_healthcare",
  "perc_effort", "perc_talent",
  "perc_rich_parents", "perc_contact",
  "pref_effort", "pref_talent",
  "pref_rich_parents", "pref_contact"
)

fit_sem3 <- lavaan::sem(
  model,
  data = db_sem3,
  estimator = "WLSMV",
  ordered = ord_vars
)

summary(fit_sem3, fit.measures = TRUE, standardized = TRUE, rsquare = TRUE)

fitmeasures(fit_sem3, c("chisq", "pvalue", "df", "cfi", "tli", "rmsea", "rmsea.ci.lower", "rmsea.ci.upper", "srmr"))

# 3.5 SEM MJP ----

db_sem4 <- db %>% 
  dplyr::select(just_pension, just_educ, just_healthcare, all_of(vars_m), age, sex, educ, income_5, pol) |> 
  na.omit()

db_sem4$just_pension <- as.numeric(db_sem4$just_pension)
db_sem4$just_educ <- as.numeric(db_sem4$just_educ)
db_sem4$just_healthcare <- as.numeric(db_sem4$just_healthcare)

db_sem4 <- db_sem4 %>% 
  rowwise() |> 
  mutate(
    index_mjp = mean(c(just_pension, just_educ, just_healthcare), na.rm = TRUE)
  ) |> 
  ungroup()

frq(db_sem4$index_mjp)

db_sem4 <- db_sem4 %>% 
  mutate(
    across(
      .cols = all_of(vars_m),
      .fns = ~as.numeric(.)
    ))

# asegurar referencias
db_sem4$income_5 <- relevel(db_sem4$income_5, ref = "Q1")
db_sem4$pol <- relevel(db_sem4$pol, ref = "Left")

# crear dummies
X_income <- model.matrix(~ income_5, data = db_sem4)[, -1, drop = FALSE]
X_pol    <- model.matrix(~ pol, data = db_sem4)[, -1, drop = FALSE]

# unir
db_sem4 <- cbind(db_sem4, as.data.frame(X_income), as.data.frame(X_pol))

# limpiar nombres
names(db_sem4) <- make.names(names(db_sem4))

db_sem4$sex_female <- ifelse(db_sem4$sex == "Female", 1, 0)

model <- c('
  perc_merit =~ perc_effort + perc_talent
  perc_nmerit =~ perc_rich_parents + perc_contact
  pref_merit =~ pref_effort + pref_talent
  pref_nmerit =~ pref_rich_parents + pref_contact

  mjp =~ just_pension + just_educ + just_healthcare

  mjp ~ perc_merit + perc_nmerit + pref_merit + pref_nmerit +
                 age + educ + sex_female +
                 income_5Q2 + income_5Q3 + income_5Q4 + income_5Q5 +
                 polCenter + polRight + polDoes.not.identify
')

ord_vars <- c(
  "just_pension", "just_educ", "just_healthcare",
  "perc_effort", "perc_talent",
  "perc_rich_parents", "perc_contact",
  "pref_effort", "pref_talent",
  "pref_rich_parents", "pref_contact"
)

fit_sem4 <- lavaan::sem(
  model,
  data = db_sem4,
  estimator = "WLSMV",
  ordered = ord_vars
)

summary(fit_sem4, fit.measures = TRUE, standardized = TRUE, rsquare = TRUE)

fitmeasures(fit_sem4, c("chisq", "pvalue", "df", "cfi", "tli", "rmsea", "rmsea.ci.lower", "rmsea.ci.upper", "srmr"))

# =============================================================================
# (2) MEDIACIÓN:  ideología -> 4 creencias -> MJP
#     X = ideología (dummies);  M = 4 factores;  Y = MJP
#     a-paths: ideología -> mediadores ;  b-paths: mediadores -> MJP
#     c' (directo): ideología -> MJP
#     Efectos indirectos con IC Monte Carlo (no bootstrap).
# =============================================================================

db_sem4

ord_vars <- c(
  "just_pension", "just_educ", "just_healthcare",
  "perc_effort", "perc_talent",
  "perc_rich_parents", "perc_contact",
  "pref_effort", "pref_talent",
  "pref_rich_parents", "pref_contact"
)

# Controles (sin ideología: en la mediación la ideología es X, no control)
ctrl <- "age + educ + sex_female + income_5Q2 + income_5Q3 + income_5Q4 + income_5Q5"

# Dummies de ideología (ref = Izquierda)
ideo <- c("polCenter", "polRight", "polDoes.not.identify")

mod_med <- paste0('
  # --- medición ---
  perc_merit  =~ perc_effort + perc_talent
  perc_nmerit =~ perc_rich_parents + perc_contact
  pref_merit  =~ pref_effort + pref_talent
  pref_nmerit =~ pref_rich_parents + pref_contact
  mjp         =~ just_pension + just_educ + just_healthcare

  # --- a-paths: ideología -> mediadores (+ controles) ---
  perc_merit  ~ a_pm_C*polCenter + a_pm_R*polRight + a_pm_N*polDoes.not.identify + ', ctrl, '
  perc_nmerit ~ a_pn_C*polCenter + a_pn_R*polRight + a_pn_N*polDoes.not.identify + ', ctrl, '
  pref_merit  ~ a_fm_C*polCenter + a_fm_R*polRight + a_fm_N*polDoes.not.identify + ', ctrl, '
  pref_nmerit ~ a_fn_C*polCenter + a_fn_R*polRight + a_fn_N*polDoes.not.identify + ', ctrl, '

  # --- b-paths + directo (c\') ---
  mjp ~ b_pm*perc_merit + b_pn*perc_nmerit + b_fm*pref_merit + b_fn*pref_nmerit +
        cp_C*polCenter + cp_R*polRight + cp_N*polDoes.not.identify + ', ctrl, '

  # --- indirectos por mediador (Right) ---
  indR_pm := a_pm_R*b_pm
  indR_pn := a_pn_R*b_pn
  indR_fm := a_fm_R*b_fm
  indR_fn := a_fn_R*b_fn
  totindR := indR_pm + indR_pn + indR_fm + indR_fn
  totalR  := totindR + cp_R

  # --- indirectos por mediador (Center) ---
  indC_pm := a_pm_C*b_pm
  indC_pn := a_pn_C*b_pn
  indC_fm := a_fm_C*b_fm
  indC_fn := a_fn_C*b_fn
  totindC := indC_pm + indC_pn + indC_fm + indC_fn
  totalC  := totindC + cp_C

  # --- indirectos por mediador (No se identifica) ---
  indN_pm := a_pm_N*b_pm
  indN_pn := a_pn_N*b_pn
  indN_fm := a_fm_N*b_fm
  indN_fn := a_fn_N*b_fn
  totindN := indN_pm + indN_pn + indN_fm + indN_fn
  totalN  := totindN + cp_N
')

fit_med <- sem(mod_med, data = db_sem4, ordered = ord_vars, estimator = "WLSMV",
               std.lv = TRUE, bounds = "standard")

summary(fit_med, standardized = TRUE, fit.measures = TRUE)

# IC Monte Carlo para TODOS los efectos definidos (indirectos/total)
set.seed(1234)
monteCarloCI(fit_med, nRep = 10000)

