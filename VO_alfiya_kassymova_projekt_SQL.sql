# 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

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


# 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné 
-- období v dostupných datech cen a mezd?

SELECT 
	*
	, round((incomes_industry /food_price),2) AS amount_of_food
FROM t_alfiya_kassymova_project_sql_primary_final akf
WHERE food_price_year IN ('2006' , '2018') 
	AND (food_category LIKE '%chléb%' OR food_category LIKE '%mléko%')
ORDER BY amount_of_food
;

# -- Nejvíc mléka rok 2018 Informační a komunikační činnosti 2830 l;
	-- Nejvíc chléba rok 2006 Peněžnictví a pojišťovnictví 2462 kg;
	-- Nejmin mléka rok 2006 Ubytování, stravování a pohostinství 788 l;
	-- Nejmin chléba rok 2006 Ubytování, stravování a pohostinství 706 kg.
	

# 3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

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
 
# 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

WITH trends_incomes AS
(SELECT 
	akf.industry 
	, akf.incomes_industry 
	, akf.payroll_year 
--	, akf2.industry 
	, akf2.incomes_industry AS following_year_income
	, akf2.payroll_year AS following_payroll_year
	, akf2.incomes_industry/akf.incomes_industry - 1 AS difference_incomes
	, CASE WHEN (akf2.incomes_industry/akf.incomes_industry - 1) > 0 THEN 1 ELSE 0 END AS difference_trend_incomes
FROM t_alfiya_kassymova_project_sql_primary_final akf
JOIN 
t_alfiya_kassymova_project_sql_primary_final akf2 
ON akf.payroll_year = akf2.payroll_year -  1  
	AND akf.industry = akf2.industry 
 GROUP BY akf.industry , akf.incomes_industry , akf.payroll_year
 ), 
 trends_food AS 
 (SELECT 
	akf3.food_category 
	, akf3.food_price 
	, akf3.food_price_year
--	, akf4.food_category 
	, akf4.food_price AS following_year_price
	, akf4.food_price_year following_year
	, akf4.food_price/akf3.food_price  - 1 AS difference_food
	, CASE WHEN (akf4.food_price/akf3.food_price  - 1) > 0 THEN 1 ELSE 0 END AS difference_trend_food
FROM t_alfiya_kassymova_project_sql_primary_final akf3
JOIN 
t_alfiya_kassymova_project_sql_primary_final akf4 
ON akf3.food_price_year = akf4.food_price_year -  1  
	AND akf3.food_category = akf4.food_category 
 GROUP BY akf3.food_category , akf3.food_price  , akf3.food_price_year
 )		
SELECT 
	industry
	, following_payroll_year
	, difference_incomes
--	, food_category 
--	, following_year_price
--	, difference_food
FROM trends_incomes ti
JOIN trends_food tf
ON ti.payroll_year = tf.food_price_year
WHERE difference_trend_incomes = 1
--	AND difference_trend_food = 1
	AND difference_incomes > 0.10
--	AND difference_food > 0.10
GROUP BY industry
-- GROUP by food_category
ORDER BY following_payroll_year
;
-- mzdy roky 2018, 2017, 2008 
#  OR for food 
			SELECT 
				--	industry
				--	, payroll_year
				--	, difference_incomes
				--	, 
					food_category 
					, following_year
					, difference_food
				FROM trends_incomes ti
				JOIN trends_food tf
				ON ti.payroll_year = tf.food_price_year
				-- WHERE difference_trend_incomes = 1
				WHERE difference_trend_food = 1
				--	AND difference_incomes > 0.10
					AND difference_food > 0.10
				-- GROUP BY industry
				GROUP by food_category
				ORDER BY following_year
				; 
-- ceny potravin 22 položky v rozmezí let 2007-2014, včetně roku 2008.
			
#-- Rok 2008 je rokem kdy růst cen potravin u 5 kategorií (Jablka konzumní, Rostlinný roztíratelný tuk, 
-- Mléko polotučné pasterované, Těstoviny vaječné, Mrkev, Vejce slepičí čerstváje) více něž 10%, 
-- nárůst mzdy o více něž 10% byl ve 3 kategoriích (Profesní, vědecké a technické činnosti, Těžba a dobývání, 
-- Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu)
			
# 5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
-- projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
			
WITH trends_incomes AS
(SELECT 
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
 ), 
 trends_food AS 
 (SELECT 
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
 ),
trends_GDP AS 
(SELECT
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
WHERE ak_GDP.year BETWEEN '2006' AND '2018')
-- SELECT 
--		YEAR
-- --	, GDP
--		, difference_GDP
--	FROM trends_GDP
--	WHERE difference_GDP > 0.02  
-- 2017	0.03, 2016	0.05, 2015	0.03, 2014	0.05, 2007	0.03, 2006	0.06	
#
			-- SELECT 
				--	industry
				-- --	, incomes_industry
				-- , payroll_year
				-- , difference_incomes
			-- FROM trends_incomes
			-- WHERE payroll_year IN ('2017', '2016', '2015', '2014', '2007', '2006')
				-- AND difference_incomes > 0.10 -- IN GENERAL y. 2007, 2016 AND 2017 MORE than 10%
				-- Kulturní, zábavní a rekreační činnosti	2017	0.109
				-- Profesní, vědecké a technické činnosti	2007	0.128
				-- Těžba a dobývání	2007	0.138
				-- Ubytování, stravování a pohostinství	2016	0.118
				-- Veřejná správa a obrana; povinné sociální zabezpečení	2017	0.101
				-- Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu	2007	0.136
				-- Vzdělávání	2017	0.108
				 #
				 			-- SELECT 
							--	 	food_category
							--	 	, food_price_year
							--		, difference_food
							-- FROM trends_food
							-- WHERE food_price_year IN ('2017', '2016', '2015', '2014', '2007', '2006')
							-- 		 AND difference_food > 0.10
							-- ORDER BY food_price_year 							
							-- IN GENERAL y. 2006, 2007, 2016, 2017
SELECT 
	GDP
	, following_year 
	, difference_GDP
FROM trends_GDP
WHERE year IN ('2017', '2016', '2015', '2014', '2007', '2006')
;

# ANSWER is more NO, there is a correlation with prices in years 2007, 2008, 2017 and 2018, but GDP is not affect the grow, 
-- because GDP in year 2015 is 5% but there are not a big food price or payroll growthes
-- Odpoved spiš NE, neexistuje přímá závislost mezi růstem HDP a růstem mezd a cen potravín. Je záznamenána určita shoda růstu, ale příma korelace není. 