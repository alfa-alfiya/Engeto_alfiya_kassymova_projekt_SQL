CREATE OR REPLACE TABLE t_alfiya_kassymova_project_sql_secondary_final AS
SELECT 
	country
	, e.`year` 					-- 1960-2020
	, GDP 
	, gini 
	, population 
FROM economies e 
WHERE e.country LIKE '%CZ%'		-- %....% zkratka zeme EU nebo celý název
; 