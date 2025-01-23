CREATE OR REPLACE TABLE t_alfiya_kassymova_project_sql_primary_final AS
SELECT 
 	cpib.name AS industry
 	, round(avg(cp.value), 2)  AS incomes_industry
 	, cp.payroll_year AS payroll_year
 	, cpc.name AS food_category
 	, round(avg(cp2.value), 2)  AS food_price
 	, YEAR(cp2.date_from) AS food_price_year
FROM czechia_price cp2  
JOIN czechia_payroll cp  			-- společné roky 2006-2018 celá "cp2"
	ON cp.payroll_year= YEAR(cp2.date_from) 
--	JOIN czechia_payroll_value_type cpvt 
--		ON cp.value_type_code =cpvt.code  	-- mzda code = 5958
		AND cp.value_type_code = 5958 
--	JOIN czechia_district cd 
--		ON cp2.region_code = cd.code		-- region_průměr
		AND cp2.region_code IS NULL 	
JOIN czechia_payroll_industry_branch cpib 
	ON cp.industry_branch_code =cpib.code 
JOIN czechia_price_category cpc 
	ON cp2.category_code =cpc.code
GROUP BY cpib.name, cp.payroll_year, cpc.name, YEAR(cp2.date_from) 
ORDER BY incomes_industry DESC, food_price DESC
;