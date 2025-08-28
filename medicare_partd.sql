-- title: Sets schema to public
SET search_path TO public;

-- title: creates 2021 table
CREATE TABLE prescribers_drug_2021 (
  Prscrbr_NPI            BIGINT,                             -- NPI
  Prscrbr_Last_Org_Name  TEXT,
  Prscrbr_First_Name     TEXT,
  Prscrbr_City           TEXT,
  Prscrbr_State_Abrvtn   CHAR(2),
  Prscrbr_State_FIPS     TEXT,
  Prscrbr_Type           TEXT,
  Prscrbr_Type_Src       TEXT,
  Brnd_Name              TEXT,
  Gnrc_Name              TEXT,
  Tot_Clms               INTEGER,
  Tot_30day_Fills        NUMERIC(14,2),
  Tot_Day_Suply          INTEGER,
  Tot_Drug_Cst           NUMERIC(18,2),
  Tot_Benes              INTEGER,
  GE65_Sprsn_Flag        TEXT,
  GE65_Tot_Clms          INTEGER,
  GE65_Tot_30day_Fills   NUMERIC(14,2),
  GE65_Tot_Drug_Cst      NUMERIC(18,2),
  GE65_Tot_Day_Suply     INTEGER,
  GE65_Bene_Sprsn_Flag   TEXT,
  GE65_Tot_Benes         INTEGER
);

-- title: creates 2022 table
CREATE TABLE prescribers_drug_2022 (
  Prscrbr_NPI            BIGINT,                             -- NPI
  Prscrbr_Last_Org_Name  TEXT,
  Prscrbr_First_Name     TEXT,
  Prscrbr_City           TEXT,
  Prscrbr_State_Abrvtn   CHAR(2),
  Prscrbr_State_FIPS     TEXT,
  Prscrbr_Type           TEXT,
  Prscrbr_Type_Src       TEXT,
  Brnd_Name              TEXT,
  Gnrc_Name              TEXT,
  Tot_Clms               INTEGER,
  Tot_30day_Fills        NUMERIC(14,2),
  Tot_Day_Suply          INTEGER,
  Tot_Drug_Cst           NUMERIC(18,2),
  Tot_Benes              INTEGER,
  GE65_Sprsn_Flag        TEXT,
  GE65_Tot_Clms          INTEGER,
  GE65_Tot_30day_Fills   NUMERIC(14,2),
  GE65_Tot_Drug_Cst      NUMERIC(18,2),
  GE65_Tot_Day_Suply     INTEGER,
  GE65_Bene_Sprsn_Flag   TEXT,
  GE65_Tot_Benes         INTEGER
);

-- title: creates 2023 table
CREATE TABLE prescribers_drug_2023 (
  Prscrbr_NPI            BIGINT,                             -- NPI
  Prscrbr_Last_Org_Name  TEXT,
  Prscrbr_First_Name     TEXT,
  Prscrbr_City           TEXT,
  Prscrbr_State_Abrvtn   CHAR(2),
  Prscrbr_State_FIPS     TEXT,
  Prscrbr_Type           TEXT,
  Prscrbr_Type_Src       TEXT,
  Brnd_Name              TEXT,
  Gnrc_Name              TEXT,
  Tot_Clms               INTEGER,
  Tot_30day_Fills        NUMERIC(14,2),
  Tot_Day_Suply          INTEGER,
  Tot_Drug_Cst           NUMERIC(18,2),
  Tot_Benes              INTEGER,
  GE65_Sprsn_Flag        TEXT,
  GE65_Tot_Clms          INTEGER,
  GE65_Tot_30day_Fills   NUMERIC(14,2),
  GE65_Tot_Drug_Cst      NUMERIC(18,2),
  GE65_Tot_Day_Suply     INTEGER,
  GE65_Bene_Sprsn_Flag   TEXT,
  GE65_Tot_Benes         INTEGER
);

SELECT * FROM PRESCRIBERS_DRUG_2021;
SELECT * FROM PRESCRIBERS_DRUG_2022;
SELECT * FROM PRESCRIBERS_DRUG_2023;


-- title: Create view called prescribers_drug_all including data from 2021-2023
-- ry indicates reporting year adds a new column called ry containing the year
CREATE VIEW prescribers_drug_all AS
SELECT 2021 AS ry, * FROM prescribers_drug_2021
UNION ALL
SELECT 2022 AS ry, * FROM prescribers_drug_2022
UNION ALL
SELECT 2023 AS ry, * FROM prescribers_drug_2023;

SELECT * FROM prescribers_drug_all; 

-------------------------------------------------------------------------------
----------------- CHECKING AND IMPUTING MISSING VALUES ------------------------

-- title: Checking no. of missing values
SELECT ry,
COUNT(*) FILTER (WHERE tot_benes IS NULL OR tot_benes::text = '') AS miss_tot_benes,
COUNT(*) FILTER (WHERE GE65_Tot_Benes IS NULL OR GE65_Tot_Benes::text = '') AS miss_GE65_Tot_Benes,
COUNT(*) FILTER (WHERE GE65_Tot_Clms IS NULL OR GE65_Tot_Clms::text = '') AS miss_GE65_Tot_Clms,
COUNT(*) FILTER (WHERE GE65_Tot_30day_Fills IS NULL OR GE65_Tot_30day_Fills::text = '') AS miss_GE65_Tot_30day_Fills,
COUNT(*) FILTER (WHERE GE65_Tot_Drug_Cst IS NULL OR GE65_Tot_Drug_Cst::text = '') AS miss_GE65_Tot_Drug_Cst,
COUNT(*) FILTER (WHERE GE65_Tot_Day_Suply IS NULL OR GE65_Tot_Day_Suply::text = '') AS miss_GE65_Tot_Day_Suply
FROM prescribers_drug_all
GROUP BY ry
ORDER BY ry;

-- title: Impute the missing value columns

-- Replace the existing view so it returns imputed values for the 6 suppressed fields
CREATE OR REPLACE VIEW prescribers_drug_all_impute AS
SELECT
  2021 AS ry,
  Prscrbr_NPI,
  Prscrbr_Last_Org_Name,
  Prscrbr_First_Name,
  Prscrbr_City,
  Prscrbr_State_Abrvtn,
  Prscrbr_State_FIPS,
  Prscrbr_Type,
  Prscrbr_Type_Src,
  Brnd_Name,
  Gnrc_Name,
  Tot_Clms,
  Tot_30day_Fills,
  Tot_Day_Suply,
  Tot_Drug_Cst,
  COALESCE(NULLIF(Tot_Benes::text, '')::INT, 5)                AS Tot_Benes,
  GE65_Sprsn_Flag,
  COALESCE(NULLIF(GE65_Tot_Clms::text, '')::INT, 5)            AS GE65_Tot_Clms,
  COALESCE(NULLIF(GE65_Tot_30day_Fills::text, '')::NUMERIC, 5) AS GE65_Tot_30day_Fills,
  COALESCE(NULLIF(GE65_Tot_Drug_Cst::text, '')::NUMERIC, 5)    AS GE65_Tot_Drug_Cst,
  COALESCE(NULLIF(GE65_Tot_Day_Suply::text, '')::INT, 5)       AS GE65_Tot_Day_Suply,
  GE65_Bene_Sprsn_Flag,
  COALESCE(NULLIF(GE65_Tot_Benes::text, '')::INT, 5)           AS GE65_Tot_Benes
FROM prescribers_drug_2021
UNION ALL
SELECT
  2022 AS ry,
  Prscrbr_NPI,
  Prscrbr_Last_Org_Name,
  Prscrbr_First_Name,
  Prscrbr_City,
  Prscrbr_State_Abrvtn,
  Prscrbr_State_FIPS,
  Prscrbr_Type,
  Prscrbr_Type_Src,
  Brnd_Name,
  Gnrc_Name,
  Tot_Clms,
  Tot_30day_Fills,
  Tot_Day_Suply,
  Tot_Drug_Cst,
  COALESCE(NULLIF(Tot_Benes::text, '')::INT, 5)                AS Tot_Benes,
  GE65_Sprsn_Flag,
  COALESCE(NULLIF(GE65_Tot_Clms::text, '')::INT, 5)            AS GE65_Tot_Clms,
  COALESCE(NULLIF(GE65_Tot_30day_Fills::text, '')::NUMERIC, 5) AS GE65_Tot_30day_Fills,
  COALESCE(NULLIF(GE65_Tot_Drug_Cst::text, '')::NUMERIC, 5)    AS GE65_Tot_Drug_Cst,
  COALESCE(NULLIF(GE65_Tot_Day_Suply::text, '')::INT, 5)       AS GE65_Tot_Day_Suply,
  GE65_Bene_Sprsn_Flag,
  COALESCE(NULLIF(GE65_Tot_Benes::text, '')::INT, 5)           AS GE65_Tot_Benes
FROM prescribers_drug_2022
UNION ALL
SELECT
  2023 AS ry,
  Prscrbr_NPI,
  Prscrbr_Last_Org_Name,
  Prscrbr_First_Name,
  Prscrbr_City,
  Prscrbr_State_Abrvtn,
  Prscrbr_State_FIPS,
  Prscrbr_Type,
  Prscrbr_Type_Src,
  Brnd_Name,
  Gnrc_Name,
  Tot_Clms,
  Tot_30day_Fills,
  Tot_Day_Suply,
  Tot_Drug_Cst,
  COALESCE(NULLIF(Tot_Benes::text, '')::INT, 5)                AS Tot_Benes,
  GE65_Sprsn_Flag,
  COALESCE(NULLIF(GE65_Tot_Clms::text, '')::INT, 5)            AS GE65_Tot_Clms,
  COALESCE(NULLIF(GE65_Tot_30day_Fills::text, '')::NUMERIC, 5) AS GE65_Tot_30day_Fills,
  COALESCE(NULLIF(GE65_Tot_Drug_Cst::text, '')::NUMERIC, 5)    AS GE65_Tot_Drug_Cst,
  COALESCE(NULLIF(GE65_Tot_Day_Suply::text, '')::INT, 5)       AS GE65_Tot_Day_Suply,
  GE65_Bene_Sprsn_Flag,
  COALESCE(NULLIF(GE65_Tot_Benes::text, '')::INT, 5)           AS GE65_Tot_Benes
FROM prescribers_drug_2023;

SELECT * FROM prescribers_drug_all_impute;

SELECT ry,
COUNT(*) FILTER (WHERE tot_benes IS NULL OR tot_benes::text = '') AS miss_tot_benes,
COUNT(*) FILTER (WHERE GE65_Tot_Benes IS NULL OR GE65_Tot_Benes::text = '') AS miss_GE65_Tot_Benes,
COUNT(*) FILTER (WHERE GE65_Tot_Clms IS NULL OR GE65_Tot_Clms::text = '') AS miss_GE65_Tot_Clms,
COUNT(*) FILTER (WHERE GE65_Tot_30day_Fills IS NULL OR GE65_Tot_30day_Fills::text = '') AS miss_GE65_Tot_30day_Fills,
COUNT(*) FILTER (WHERE GE65_Tot_Drug_Cst IS NULL OR GE65_Tot_Drug_Cst::text = '') AS miss_GE65_Tot_Drug_Cst,
COUNT(*) FILTER (WHERE GE65_Tot_Day_Suply IS NULL OR GE65_Tot_Day_Suply::text = '') AS miss_GE65_Tot_Day_Suply
FROM prescribers_drug_all_impute
GROUP BY ry
ORDER BY ry;

-- title: Detect NPIs with more than one unique provider name
SELECT Prscrbr_NPI, COUNT(DISTINCT Prscrbr_Last_Org_Name) AS name_variants
FROM prescribers_drug_all_impute
GROUP BY Prscrbr_NPI
HAVING COUNT(DISTINCT Prscrbr_Last_Org_Name) > 1
ORDER BY name_variants;

------------------------------------------------------------------------------------
--------------------------OBJECTIVES TO ANALYZE-------------------------------------

-- title: copy the view table in the table (physical table) section
CREATE TABLE prescribers_drug_final AS 
(SELECT * FROM prescribers_drug_all_impute);

SELECT * FROM prescribers_drug_final;

-- title: Creating indexes for prescribers_drug_final
CREATE INDEX Prscrbr_NPI_final ON prescribers_drug_final (Prscrbr_NPI);
CREATE INDEX Prscrbr_City_final ON prescribers_drug_final (Prscrbr_City);
CREATE INDEX Prscrbr_State_final ON prescribers_drug_final (Prscrbr_State_Abrvtn);
CREATE INDEX Brnd_Name_final ON prescribers_drug_final (Brnd_Name);
CREATE INDEX Gnrc_Name_final ON prescribers_drug_final (Gnrc_Name);

-- title: 1. Identify top prescribers by total drug cost (overall and within each Brnd_Name/Gnrc_Name)
SELECT * FROM prescribers_drug_final;

CREATE INDEX Q1_top_prescribers ON prescribers_drug_final 
(prscrbr_npi, prscrbr_first_name, prscrbr_last_org_name);

SELECT prscrbr_npi,PRSCRBR_FIRST_NAME,PRSCRBR_LAST_ORG_NAME,SUM(TOT_DRUG_CST) AS TOTAL_DRUG_COST
FROM prescribers_drug_final
GROUP BY 1,2,3
ORDER BY 4 DESC LIMIT 10;

-- title: 2. Compare brand vs. generic utilization and costs by provider type

SELECT 
    Prscrbr_Type,
    SUM(CASE WHEN Brnd_Name <> Gnrc_Name THEN Tot_Clms ELSE 0 END) AS brand_claims,
    SUM(CASE WHEN Brnd_Name = Gnrc_Name THEN Tot_Clms ELSE 0 END) AS generic_claims,
    SUM(CASE WHEN Brnd_Name <> Gnrc_Name THEN Tot_Drug_Cst ELSE 0 END) AS brand_cost,
    SUM(CASE WHEN Brnd_Name = Gnrc_Name THEN Tot_Drug_Cst ELSE 0 END) AS generic_cost,
    ROUND(
    	SUM(CASE WHEN Brnd_Name = Gnrc_Name THEN Tot_Clms ELSE 0 END)::numeric
       /NULLIF(SUM(Tot_Clms),0) * 100, 2) AS pct_generic_claims,
    ROUND(
        SUM(CASE WHEN Brnd_Name <> Gnrc_Name THEN Tot_Clms ELSE 0 END)::numeric
        /NULLIF(SUM(Tot_Clms),0) * 100, 2) AS pct_brand_claims
FROM prescribers_drug_final
GROUP BY Prscrbr_Type
ORDER BY brand_cost DESC;

-- title: 3. Rank specialties by prescribing volume and beneficiary reach.

WITH speciality AS (
	SELECT Prscrbr_Type, SUM(Tot_Clms) AS total_claims, SUM(tot_benes) AS total_beneficiaries
	FROM prescribers_drug_final
	GROUP BY Prscrbr_Type
)
SELECT Prscrbr_Type,total_claims,total_beneficiaries,
		RANK() OVER(ORDER BY TOTAL_CLAIMS DESC) AS rank_by_claims,
		RANK() OVER(ORDER BY total_beneficiaries DESC) AS rank_by_beneficiaries
FROM SPECIALITY
GROUP BY Prscrbr_Type,total_claims,total_beneficiaries
ORDER BY TOTAL_CLAIMS DESC 
LIMIT 10;

-- title: 4. Profile state-level prescribing across states.
SELECT prscrbr_state_abrvtn, SUM(TOT_CLMS) AS TOTAL_CLAIMS, SUM(TOT_DRUG_CST) AS TOTAL_DRUG_COST
FROM prescribers_drug_final
GROUP BY 1
ORDER BY 3 DESC;

-- title: 5. Find drugs with highest 65+ utilization and contrast with overall.
SELECT BRND_NAME, GNRC_NAME, SUM(Tot_Clms) AS total_claims, SUM(Tot_Drug_Cst) AS total_cost,
SUM(COALESCE(GE65_Tot_Clms,0)) AS claims_65plus, SUM(COALESCE(GE65_Tot_Drug_Cst,0)) AS cost_65plus,
ROUND(SUM(COALESCE(GE65_Tot_Clms,0))::NUMERIC/NULLIF(SUM(Tot_Clms),0) * 100, 2) AS pct_claims_from_65plus,
ROUND(SUM(COALESCE(GE65_Tot_Drug_Cst,0))::numeric/NULLIF(SUM(Tot_Drug_Cst),0) * 100, 2) AS pct_cost_from_65plus
FROM prescribers_drug_final
GROUP BY Brnd_Name, Gnrc_Name
HAVING SUM(COALESCE(GE65_Tot_Clms,0)) > 0
ORDER BY claims_65plus DESC
LIMIT 20;

-- title: 6. Flag high-cost drugs via average cost per beneficiary.
SELECT BRND_NAME, GNRC_NAME, SUM(Tot_Drug_Cst) AS total_cost, SUM(Tot_Benes) AS total_beneficiaries,
ROUND(SUM(Tot_Drug_Cst)::numeric/NULLIF(SUM(Tot_Benes),0),2) AS avg_cost_per_beneficiary
FROM prescribers_drug_final
GROUP BY Brnd_Name, Gnrc_Name
HAVING SUM(Tot_Benes)>0
ORDER BY avg_cost_per_beneficiary DESC
LIMIT 20;


-- title: 7. Rank prescribers by unique beneficiaries served, with drill-down by drug type.
SELECT
    Prscrbr_NPI,
    COALESCE(MAX(Prscrbr_First_Name), '') AS first_name,
    COALESCE(MAX(Prscrbr_Last_Org_Name), '') AS last_org_name,
    SUM(COALESCE(Tot_Benes,0)) AS approx_beneficiaries
FROM prescribers_drug_all
GROUP BY Prscrbr_NPI
ORDER BY approx_beneficiaries DESC
LIMIT 20;   -- top 20 prescribers

-- Show how each prescriber’s beneficiaries are distributed across drugs

SELECT Prscrbr_NPI,Brnd_Name,Gnrc_Name,SUM(COALESCE(Tot_Benes,0)) AS approx_beneficiaries
FROM prescribers_drug_all
GROUP BY Prscrbr_NPI, Brnd_Name, Gnrc_Name
ORDER BY Prscrbr_NPI, approx_beneficiaries DESC;

-- title: 8. Compare cost distribution across specialties, highlighting outliers via percentiles/window stats.

-- Objective 8A: Total drug cost by provider specialty
SELECT Prscrbr_Type,SUM(Tot_Drug_Cst) AS total_cost,AVG(Tot_Drug_Cst) AS avg_cost_per_record
FROM prescribers_drug_all
GROUP BY Prscrbr_Type
ORDER BY total_cost DESC;

-- Objective 8B: Detect high-cost specialties compared to others
-- Uses percentile_cont to compute quartiles of cost distribution

WITH specialty_costs AS (
    SELECT Prscrbr_Type, SUM(Tot_Drug_Cst) AS total_cost
    FROM prescribers_drug_all
    GROUP BY Prscrbr_Type
),
quartiles AS (
    SELECT
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_cost) AS p25,
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY total_cost) AS median,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_cost) AS p75
    FROM specialty_costs
)
SELECT
    s.Prscrbr_Type,s.total_cost,q.p25,q.median,q.p75
FROM specialty_costs s
CROSS JOIN quartiles q
ORDER BY s.total_cost DESC;


-- title: 9. For each state and specialty, list the most-prescribed brand by claims.

-- Find the most prescribed drug (by claims) for each state & specialty
WITH drug_totals AS (
    SELECT Prscrbr_State_Abrvtn AS state,Prscrbr_Type,Brnd_Name,SUM(Tot_Clms) AS total_claims
    FROM prescribers_drug_all
    GROUP BY Prscrbr_State_Abrvtn, Prscrbr_Type, Brnd_Name
),
ranked AS (
    SELECT state,Prscrbr_Type,Brnd_Name,total_claims,
        ROW_NUMBER() OVER (PARTITION BY state, Prscrbr_Type ORDER BY total_claims DESC) AS RN
    FROM drug_totals
)
SELECT state,Prscrbr_Type,Brnd_Name,total_claims,RN
FROM ranked
WHERE rn = 1   -- pick only the top drug in each state & specialty
ORDER BY state,total_claims DESC;














