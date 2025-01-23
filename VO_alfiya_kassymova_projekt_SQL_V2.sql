#1
WITH trends AS
(SELECT 
	akf.industry 
	, akf.incomes_industry 
	, akf.payroll_year 
--	, akf2.industry 
	, akf2.incomes_industry AS following_year_income
	, akf2.payroll_year AS following_payroll_year
	, akf2.incomes_industry/akf.incomes_industry - 1 AS difference
	, CASE WHEN (akf2.incomes_industry/akf.incomes_industry - 1) > 0 THEN 1 ELSE 0 END AS difference_trend
FROM t_alfiya_kassymova_project_sql_primary_final akf
JOIN 
t_alfiya_kassymova_project_sql_primary_final akf2 
ON akf.payroll_year = akf2.payroll_year -  1  
	AND akf.industry = akf2.industry 
 GROUP BY akf.industry , akf.incomes_industry , akf.payroll_year
 )
 SELECT * FROM trends
 WHERE difference_trend = 0
;

# Ano, v některých odvětvích mzdy klesají.


# 2.
SELECT 
	industry 
	, ROUND(AVG(incomes_industry),2) AS average_incomes 
	, payroll_year
	, food_category 
	, ROUND(AVG(food_price),2) AS average_food_price
	, ROUND((incomes_industry /food_price),0) AS amount_of_food
FROM t_alfiya_kassymova_project_sql_primary_final akf
WHERE food_price_year IN ('2006' , '2018') 
	AND (food_category LIKE '%chléb%' OR food_category LIKE '%mléko%')
GROUP BY payroll_year , food_category
ORDER BY amount_of_food
;
	

# 3. 

WITH trends AS
(SELECT 
	akf.food_category 
	, akf.food_price 
	, akf.food_price_year
--	, akf2.food_category 
	, akf2.food_price AS following_year_price
	, akf2.food_price_year AS following_year
	, akf2.food_price/akf.food_price  - 1 AS difference
	, CASE WHEN (akf2.food_price/akf.food_price  - 1) > 0 THEN 1 ELSE 0 END AS difference_trend
FROM t_alfiya_kassymova_project_sql_primary_final akf
JOIN 
t_alfiya_kassymova_project_sql_primary_final akf2 
ON akf.food_price_year = akf2.food_price_year -  1  
	AND akf.food_category = akf2.food_category 
 GROUP BY akf.food_category , akf.food_price  , akf.food_price_year
 )
 SELECT 
 	food_category
-- 	, food_price
 	, food_price_year
 	, following_year
-- 	, following_year_price
 	, difference
 FROM trends
 WHERE difference_trend = 1
 GROUP BY food_category
 ORDER BY difference
 ;

# Rostlinný roztíratelný tuk r.2007 0,072%, Přírodní minerální voda uhličitá r.2007 0,52%
 
# 4. 

WITH value_changes AS
(SELECT 
	ROUND(AVG((akf.incomes_industry)),2) AS average_incomes
	, akf.payroll_year
	, ROUND(AVG((akf.food_price)),2) AS average_food_price
	, akf.food_price_year
	, ROUND(AVG((akf2.incomes_industry)),2)/ROUND(AVG((akf.incomes_industry)),2) - 1 AS calc_incomes
	, ROUND(AVG((akf2.food_price)),2)/ROUND(AVG((akf.food_price)),2) - 1 AS calc_food
FROM t_alfiya_kassymova_project_sql_primary_final akf
JOIN
t_alfiya_kassymova_project_sql_primary_final akf2 
ON akf.payroll_year = akf2.payroll_year - 1
GROUP BY akf.payroll_year , akf.food_price_year, akf2.payroll_year, akf2.food_price_year 
ORDER BY payroll_year
)
SELECT
	payroll_year
	, calc_incomes - calc_food AS difference
	, CASE WHEN (calc_incomes - calc_food) > 0.1 THEN 1 ELSE 0 END AS growth
FROM value_changes
ORDER BY payroll_year
;
	
#Neexistuje rok s rozdílem 10%

			
# 5.

CREATE OR REPLACE VIEW trends_incomes AS
 SELECT 
	akf.industry 
	, akf.incomes_industry 
	, akf.payroll_year 
--	, akf2.industry 
	, akf2.incomes_industry AS following_year_income
	, akf2.payroll_year AS following_payroll_year
	, round((akf2.incomes_industry/akf.incomes_industry - 1),3) AS difference_incomes
	, CASE WHEN (akf2.incomes_industry/akf.incomes_industry - 1) > 0 THEN 1 ELSE 0 END AS difference_trend_incomes
FROM t_alfiya_kassymova_project_sql_primary_final akf
JOIN 
t_alfiya_kassymova_project_sql_primary_final akf2 
ON akf.payroll_year = akf2.payroll_year -  1  
	AND akf.industry = akf2.industry 
 GROUP BY akf.industry , akf.incomes_industry , akf.payroll_year
;

CREATE OR REPLACE VIEW trends_food AS
SELECT 
	akf3.food_category 
	, akf3.food_price 
	, akf3.food_price_year
--	, akf4.food_category 
	, akf4.food_price AS following_year_price
	, akf4.food_price_year following_year
	, round((akf4.food_price/akf3.food_price  - 1),3) AS difference_food
	, CASE WHEN (akf4.food_price/akf3.food_price  - 1) > 0 THEN 1 ELSE 0 END AS difference_trend_food
FROM t_alfiya_kassymova_project_sql_primary_final akf3
JOIN 
t_alfiya_kassymova_project_sql_primary_final akf4 
ON akf3.food_price_year = akf4.food_price_year -  1  
	AND akf3.food_category = akf4.food_category 
 GROUP BY akf3.food_category , akf3.food_price  , akf3.food_price_year
 ;

CREATE OR REPLACE VIEW trends_GDP AS
SELECT
	ak_GDP.YEAR AS year
	, ak_GDP.GDP
	, ak_GDP2.YEAR AS following_year
	, ak_GDP2.GDP AS following_year_GDP
	, round((ak_GDP2.GDP/ak_GDP.GDP-1),3) AS difference_GDP
	, CASE WHEN (ak_GDP2.GDp/ak_GDP.GDP-1) > 0 THEN 1 ELSE 0 END AS difference_trend_GDP
FROM t_alfiya_kassymova_project_sql_secondary_final ak_GDP
JOIN
t_alfiya_kassymova_project_sql_secondary_final ak_GDP2
ON ak_GDP.YEAR = ak_GDP2.YEAR - 1
WHERE ak_GDP.year BETWEEN '2006' AND '2018'
;

CREATE OR REPLACE VIEW difference_GDP AS
SELECT 
	YEAR
	, GDP
	, difference_GDP
FROM trends_gdp tg 
WHERE difference_GDP > 0.02 -- zvolené číslo 2% (nejrvé jsem měla nárůst o 5%, 
										-- ale ve výsledku byly jen tři hodnoty, proto jsem si zvolila nárůst o 2% pro přesněkší analýzu)
;

# 2017 , 2016 , 2015 , 2014	, 2007 , 2006

CREATE OR REPLACE VIEW difference_incomes AS
SELECT 
	industry
	, incomes_industry
	, payroll_year
	, difference_incomes
FROM trends_incomes
WHERE payroll_year IN ('2017', '2016', '2015', '2014', '2007', '2006')
	AND difference_incomes > 0.10 
;
	#IN GENERAL y. 2007, 2016 AND 2017 MORE than 10%
	
CREATE OR REPLACE VIEW difference_food_price AS
 SELECT 
	food_category
	, food_price_year
	, difference_food
FROM trends_food
WHERE food_price_year IN ('2017', '2016', '2015', '2014', '2007', '2006')
	AND difference_food > 0.10
ORDER BY food_price_year 
;
-- IN GENERAL y. 2006, 2007, 2016, 2017

SELECT 
	GDP
	, following_year 
	, difference_GDP
FROM trends_GDP
WHERE year IN ('2017', '2016', '2015', '2014', '2007', '2006')
;
 
-- Odpoved spiš NE, neexistuje přímá závislost mezi růstem HDP a růstem mezd a cen potravín
-- Je záznamenána určita shoda růstu, ale příma korelace není. 