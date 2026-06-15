---
title: "Preferences for Market-Based Welfare"
subtitle: "Disentangling the role of merit and privilege beliefs"
author: "Andreas Laffert · Juan Carlos Castillo · René Canales · Tomás Urzúa"
institute: "Department of Sociology, University of Chile"
date: today
format:
  revealjs:
    theme: simple
    slide-number: true
    transition: fade
    incremental: false
    fig-align: center
    width: 1200
    height: 750
---

# Context and motivation

## Marketized welfare and its moral underpinnings

- Commodification reshaped *who deserves what, and why*
- Policy feedback → rising **market justice preferences**: income-based access to health, education, pensions
- Moral economy: deservingness criteria mediate how structure shapes attitudes
- **Chile**: deep commodification; individual responsibility institutionalized across all three domains

::: notes
Anchor: meritocracy as the moral engine that legitimizes market-based welfare.
:::

## The gap: meritocracy is treated as *one* thing

- NICER framework → focus on the **effort** dimension of deservingness, operationalized as meritocratic beliefs
- Most work uses a single, summative notion of "meritocracy"
- This masks heterogeneity along **two crossed distinctions**:
  - meritocratic vs. **non-meritocratic** (privilege) beliefs
  - **perceptions** (what *is*) vs. **preferences** (what *ought to be*)
- Largely sidelined: **non-meritocratic** beliefs — privilege as a route to success

## A multidimensional framework

|                       | Perceptions (*is*)               | Preferences (*ought*)              |
|-----------------------|----------------------------------|------------------------------------|
| **Meritocratic**      | effort/talent *are* rewarded     | effort/talent *should be* rewarded |
| **Non-meritocratic**  | privilege/contacts *drive* success | privilege *should* be a basis for reward |

- Four conceptually distinct belief dimensions → one outcome
- Following Castillo et al. (2023), multidimensional measurement of meritocracy

## Research question and hypotheses

- **RQ:** How do the four belief dimensions shape support for market-based welfare (health, education, pensions)?
- **H1** — Meritocratic *perceptions* → (+) market justice
- **H2** — Meritocratic *preferences* → (+) market justice
- **H3** — Non-meritocratic *perceptions* (seeing privilege) → (–) market justice
- **H4** — Non-meritocratic *preferences* (endorsing privilege) → *open / exploratory*

# Methodology

## Data

- Cross-sectional survey of urban Chilean adults
- Analytic sample: **N = 2,521**
- All constructs from ordinal Likert agreement items
- Chile as a strong test case: high commodification of welfare

## Measures

**Dependent variable — Market justice preferences (latent)**

- Justifying income-based access to three core services: **healthcare · pensions · education**
- e.g. *"Is it fair that people with higher incomes access better healthcare than those with lower incomes?"* (same for pensions, education)
- 5-point Likert (1 = strongly disagree → 5 = strongly agree)
- Three items → one latent factor

**Meritocratic beliefs (4 latent dimensions)**

- Same items as the original scale of Castillo et al. (2023) — *introduced above*
- 4-point Likert items

**Controls**

- Sex (man / woman) · age · education (years) · income quintile · political identification (left / center / right / none)

## Analytical strategy: why SEM (not regression)

- Each construct = **latent variable** built from multiple ordinal items
- Two-step logic: **measurement model (CFA)** → **structural model**
- Estimator: **DWLS** with robust (mean- and variance-adjusted) SE — items treated as ordinal
- Latent dimensions allowed to correlate; four **distinct, simultaneous** paths to a latent outcome

## What the SEM approach buys us

- **Corrects measurement error** → no attenuation in structural estimates
- **Discriminant validity:** CFA shows the four dimensions are *empirically distinct*, not one scale
- **Separates** descriptive (*is*) from normative (*ought*), and **merit** from **privilege**
- Models a **multidimensional outcome** (three welfare domains at once)
- *For the field:* sharpens the deservingness toolkit — what people **see** vs. what they **endorse**

::: notes
This is the core methodological contribution slide — the "what others can learn" part. A summative meritocracy index would average away effects that point in opposite directions.
:::

# Results

## Descriptives + measurement model

- Likert distributions of the four belief scales and market justice items
- *[insert descriptive Likert plots here]*
- Measurement model fits well; four dimensions empirically separable

::: notes
Replace bullet with the actual likert plots (e.g., `sjPlot::plot_likert` or `ggplot`).
:::

## Model fit

- **CFI = .973**  ·  **TLI = .989**
- **RMSEA = .044** [.041–.047]  ·  **SRMR = .038**
- χ²(134) = 798.1 (scaled), p < .001
- Estimator: DWLS robust · N = 2,521
- R²(market justice) = **.31**

## Structural model: four paths, four stories

| Predictor (latent)              | β (std) | p        |
|---------------------------------|:-------:|:--------:|
| Meritocratic perceptions        | **+.08**  | <.001    |
| Non-meritocratic perceptions    | **−.20**  | <.001    |
| Meritocratic preferences        | +.02    | .58 (n.s.) |
| **Non-meritocratic preferences**| **+.37**  | **<.001** |

- Controls: female −.13; Right +.33, Center +.13, no party ID +.17
- **Income quintiles all n.s.** → driven by beliefs, not income position

::: notes
Punchline: endorsing privilege is the strongest predictor of market-justice support — larger than any meritocratic belief, and larger than income or demographics.
:::

## The picture in one diagram

- *[insert SEM path diagram here — highlight the +.37 path from non-meritocratic preferences]*

::: notes
Use `semPlot::semPaths` or a hand-drawn tikz; thicken the non-meritocratic-preferences → MJP arrow.
:::

# Discussion and conclusions

## Answering the hypotheses

- **H1 supported** — seeing merit modestly raises market-justice support (+.08)
- **H3 supported** — seeing privilege *lowers* it (−.20): awareness of unearned advantage undermines market support
- **H2 not supported** — preferring merit has no effect (n.s.; likely limited variance)
- **H4 — the headline** — *endorsing* privilege is the **strongest** driver (+.37)

## Dialogue with the literature

- Effects diverge sharply *within* "meritocracy" → vindicates the multidimensional approach
- Counterintuitive core finding: embracing **privilege** ≠ rejecting markets — it is the *strongest* legitimizer
- Speaks to:
  - **Market justice / commodification** (Lindh; Busemeyer & Iversen)
  - **NICER deservingness — effort criterion** (Knotz et al.): merit is heterogeneous; *is* ≠ *ought*
  - Meritocracy as legitimation of market inequality

## Methodological takeaways

- **Disaggregate** compound moral constructs: perception vs. preference; merit vs. privilege
- SEM measures latent beliefs **cleanly** (error-free) and tests them **simultaneously**
- A **transferable strategy**: other deservingness criteria (NICER), other domains, other countries
- *Closing line:* measuring meritocracy as one thing hides effects that point in opposite directions

## (Optional) Robustness & validity checks

- Competing models: 1-factor vs. 2-factor vs. **4-factor** (χ² difference test)
- Discriminant validity: ω / composite reliability, AVE, HTMT
- Measurement invariance across gender and political identification
- Survey design: longitudinal/complex-sample weights and clustering

::: notes
Optional slide for a methods audience — shows the checks behind the "four distinct dimensions" claim. Cut if over 10 min.
:::

## Thank you

- andreas.laffert@uchile.cl
- Welfare Attitudes Research Network (WARN)
