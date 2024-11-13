--Total Trials and Deaths by Century
SELECT century, 
  SUM(tried) AS total_tried, 
  SUM(SAFE_CAST(deaths AS INT64)) AS total_deaths,
FROM
  `angular-century-438118-m7.witchtrials.trials`
GROUP BY
  century
ORDER BY 
  century;
--Total Trials and Deaths by Decade
SELECT decade, 
  SUM(tried) AS total_tried, 
  SUM(SAFE_CAST(deaths AS INT64)) AS total_deaths,
FROM
  `angular-century-438118-m7.witchtrials.trials`
GROUP BY
  decade
ORDER BY 
  decade;
--Average Death Rate per Trial by Century
SELECT century, 
  AVG(SAFE_CAST(deaths AS INT64)/NULLIF(tried, 0)) * 100 AS avgdeathrate
FROM
  `angular-century-438118-m7.witchtrials.trials`
GROUP BY
  century
ORDER BY 
  century;
--Average Death Rate per Trial by Decade
SELECT decade, 
  AVG(SAFE_CAST(deaths AS INT64)/NULLIF(tried, 0)) * 100 AS avgdeathrate
FROM
  `angular-century-438118-m7.witchtrials.trials`
GROUP BY
  decade
ORDER BY 
  decade;
--Trials Without Deaths by Century
SELECT COUNT(*) AS trials_without_deaths,
  century,
FROM
  `angular-century-438118-m7.witchtrials.trials`
WHERE 
  CAST(NULLIF(deaths, 'NA') AS INT64) = 0
GROUP BY
  century;
--Trials and Deaths by Country 
SELECT 	
  gadm_adm0 AS country, 
  SUM(SAFE_CAST(tried AS INT64)) AS total_trials,
  SUM(SAFE_CAST(NULLIF(deaths, 'NA') AS INT64)) AS total_deaths
FROM 
  `angular-century-438118-m7.witchtrials.trials`
GROUP BY 
  country
ORDER BY 
  total_deaths DESC;
--Percentage of Trials Resulting in Deaths by Country
SELECT gadm_adm0 AS country,
  COUNT(*) AS total_trials,
  SUM(CASE WHEN CAST(NULLIF(deaths, 'NA') AS INT64) > 0 THEN 1 ELSE 0 END) AS trials_with_deaths,
  ROUND((SUM(CASE WHEN CAST(NULLIF(deaths, 'NA') AS INT64) > 0 THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS death_trial_percentage
FROM 
  `angular-century-438118-m7.witchtrials.trials`
GROUP BY 
  country
ORDER BY 
  death_trial_percentage DESC;
--Identify “Outlier” Trials with Unusually High Death Counts
WITH avg_deaths AS (
SELECT AVG(CAST(NULLIF(deaths, 'NA') AS FLOAT64)) AS overall_avg_deaths
FROM 
  `angular-century-438118-m7.witchtrials.trials`
)
SELECT city, gadm_adm0 AS country, century, decade,
  CAST(NULLIF(deaths, 'NA') AS INT64) AS deaths
FROM 
  `angular-century-438118-m7.witchtrials.trials`, avg_deaths
WHERE 
  CAST(NULLIF(deaths, 'NA') AS INT64) > overall_avg_deaths * 2
ORDER BY 
  deaths DESC;
--Proportion of Witch Trials by Decade for Each Country
SELECT gadm_adm0 AS country, 
  decade,
  COUNT(*) AS trials_in_decade,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY gadm_adm0), 2) AS percent_of_total_trials
FROM 
  `angular-century-438118-m7.witchtrials.trials`
GROUP BY 
  country, decade
ORDER BY 
  country, percent_of_total_trials DESC;


