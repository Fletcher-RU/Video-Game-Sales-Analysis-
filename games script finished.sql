-- What are the top 5 best selling games for each locations?
-- Skills used: SELECT, Sorting, Limiting results

-- Top 10 Global Sales

SELECT `name`, Platform, `Year`, Genre, Publisher, Global_Sales
FROM vgsales
ORDER BY Global_sales DESC LIMIT 10;

-- Top 10 North American Sales

SELECT `name`, Platform, `Year`, Genre, Publisher, NA_Sales
FROM vgsales
ORDER BY NA_sales DESC LIMIT 10;

-- Top 10 Japan Sales

SELECT `name`, Platform, `Year`, Genre, Publisher, JP_Sales
FROM vgsales
ORDER BY JP_sales DESC LIMIT 10;

-- Top 10 European Sales

SELECT `name`, Platform, `Year`, Genre, Publisher, EU_Sales
FROM vgsales
ORDER BY EU_sales DESC LIMIT 10;


-- Which region contributes the most to global sales across all games? 
-- Skills: Aggregation, Rounding, Combining results 

SELECT
'North America' AS region,
ROUND (SUM(NA_Sales) / SUM(Global_Sales)*100, 2) AS percent_of_sales
FROM vgsales
UNION ALL 
SELECT
'Europe',
ROUND (SUM(EU_Sales) / SUM(Global_Sales) * 100, 2)
FROM vgsales
UNION ALL
SELECT
'Japan',
ROUND(SUM(JP_sales) / SUM(global_sales) * 100, 2)
FROM vgsales
UNION ALL
SELECT
'Other',
ROUND(SUM(Other_Sales) / SUM(global_sales) * 100, 2)
FROM vgsales;

-- This creates a table which shows the percentage each region contributes to the global sales
-- of the video games


-- How have video game sales changed year over year.  
-- Skills used: Aggregation, grouping, Sorting

SELECT `Year`, ROUND(SUM(Global_Sales), 2) AS Total_Global_Sales
FROM vgsales 
GROUP BY `Year`
ORDER BY Total_Global_Sales DESC;


-- Which platform has the highest global sales
-- Skills used Aggregation, Grouping, Rounding

SELECT Platform, ROUND(SUM(Global_Sales), 2) As Total_Global_Sales
FROM vgsales
GROUP BY Platform
ORDER BY Total_Global_Sales DESC;


-- Which is the top publisher across all individual regions?
-- Skills Used: CTEs, aggregation, Subqueries

WITH PublisherSales AS(
	SELECT
		Publisher,
        SUM(NA_Sales) AS Total_Na_Sales,
        SUM(EU_Sales) AS Total_EU_Sales,
        SUM(JP_Sales) AS Total_JP_Sales,
		SUM(Other_Sales) AS Total_Other_Sales
	FROM vgsales
    GROUP BY PUBLISHER
)
SELECT 
	(SELECT Publisher FROM PublisherSales ORDER BY Total_NA_Sales DESC LIMIT 1) AS Top_NA_Publisher,
    (SELECT Publisher FROM PublisherSales ORDER BY Total_EU_Sales DESC LIMIT 1) AS Top_EU_Publisher,
    (SELECT Publisher FROM PublisherSales ORDER BY Total_JP_Sales DESC LIMIT 1) AS Top_JP_Publisher,
    (SELECT Publisher FROM PublisherSales ORDER BY Total_Other_Sales DESC LIMIT 1) AS Top_Other_Publisher;

-- What percenatge of global sales does the top 1% of games account for 
-- Skills used: Subqueries, Aggregation, Ordering, Table aliases

SELECT COUNT(`RANK`) FROM vgsales;
-- finds there are 16327 total entries so we need to find the top 163 games

SELECT 
	ROUND(
		(SELECT SUM(Global_sales) 
		FROM(
			SELECT Global_Sales
			FROM vgsales
			ORDER BY Global_sales DESC
			LIMIT 163
	) AS TOP_10P_SALES) 
    /SUM(Global_Sales) * 100, 2) AS Top_10_Percent
FROM vgsales; 


