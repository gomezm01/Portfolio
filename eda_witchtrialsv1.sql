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
--Average Death Rate per Trial by Century
SELECT century, AVG(SAFE_CAST(deaths AS INT64)/NULLIF(tried, 0)) * 100 AS avgdeathrate
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
--Trials Without Deaths by Century
SELECT 
  COUNT(*) AS trials_without_deaths,
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
