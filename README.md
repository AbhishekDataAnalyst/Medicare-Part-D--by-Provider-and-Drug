# Medicare-Part-D--by-Provider-and-Drug

Source: CMS Medicare Part D Prescribers — by Provider & Drug (public).
Dataset:- https://data.cms.gov/provider-summary-by-type-of-service/medicare-part-d-prescribers/medicare-part-d-prescribers-by-provider-and-drug

# Domain
The Medicare Part D Prescribers by Provider and Drug dataset provides information on prescription drugs prescribed to Medicare beneficiaries enrolled in Part D by physicians and other health care providers. This dataset contains the total number of prescription fills dispensed and the total drug cost paid, organised by prescribing National Provider Identifier (NPI), drug brand name (if applicable), and drug generic name.

# Data Collection
Data is collected from data.cms.gov. Go to data.cms.gov -> explore data -> in the search box type "medicare part d" -> click Medicare Part D Prescribers by Provider and Drug dataset. It is a public-use dataset.

- Years covered: 2021–2023 (extendable). One CSV file for each year
- Each CSV file is around 3-4 GB of data (approx 25+ million rows of data for each file)

# Objectives 
1. Identify top prescribers by total drug cost.
2. Compare brand vs. generic utilization and costs by provider type.
3. Rank specialities by prescribing volume and beneficiary reach.
4. Profile state-level prescribing across states.
5. Find drugs with the highest 65+ utilization and contrast with the overall.
6. Flag high-cost drugs via average cost per beneficiary.
7. Rank prescribers by unique beneficiaries served, with drill-down by drug type.
8. Compare cost distribution across specialities, highlighting outliers via percentiles/window stats.
9. For each state and speciality, list the most-prescribed brand  by claims.

# Project highlights
- Data volume: 10 GB+ across years (large CSVs → PostgreSQL for scale).
- Tools: PostgreSQL (via DBeaver), VS Code for Python (pandas,sqlalchemy, matplotlib, seaborn).
- Reproducible objectives (1-9): SQL + Python outputs saved to /outputs as CSV + PNG charts.
- Actionable insights: Market concentration, prescriber influence, geographic inefficiencies, ageing impact, and generic gap.

# Interpretation

1. Market Concentration: Pharma revenues rely heavily on a few blockbuster speciality drugs.
2. Prescriber Influence: Certain high-volume prescribers or specialities disproportionately affect cost trends.
3. Geographic Inefficiencies: Formularies and prescribing norms vary widely by state → unequal drug access and spending.
4. Ageing Population Impact: The 65+ cohort sustains demand for cardiovascular, metabolic, and neurological drugs.
5. Generic Gap: Where generics exist, they are underutilized in specific states or specialities → wasted cost savings.

# Business impacts

1. For Payers (CMS / Insurers)
    - Expand generic substitution mandates where evidence supports equivalent efficacy.
    - Introduce prescriber feedback dashboards benchmarking their generic vs brand usage.
    - Negotiate value-based contracts with pharma for high-cost speciality drugs.

2. For Pharma Companies
    - Target education campaigns in specialities/states overusing brands where generics exist.
    - Invest in real-world evidence to prove the  value of branded therapies where substitution pressure is high.
    - Anticipate Medicare formulary tightening by developing biosimilars/alternatives.

3. For Policymakers
    - Incentivise biosimilar adoption through pricing and regulatory reform.
    - Standardise formularies across states to reduce cost disparities.
    - Enhance Medicare negotiation authority for the highest-cost drugs.

4. For Health Systems / Hospitals
    - Implement prescription stewardship programs for costly drug classes.
    - Educate providers on cost-effective prescribing alternatives.
    - Monitor prescriber-level outliers for quality and compliance risks.
  
