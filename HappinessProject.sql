-- IMPORT HAPPINESS DATA INTO MYSQL DATABASE

USE project;

SELECT *FROM happiness_nineteen;

SELECT country_name, social_support FROM project.happiness_twenty
WHERE social_support <= 0.881475747;

-- USE AGGREGATE FORMULA SUCH AS SUM, COUNT, AVERAGE TO PERFORM DATA ANALYSIS ON THE PROJECT

-- COUNT 
-- Count the number of countries in Happiness19 and 20

SELECT COUNT(country_name) AS num
FROM happiness_nineteen;

SELECT COUNT(country_name) AS num
FROM happiness_twenty;

-- SUM
-- Add the total sum of social_support, healthy life expectancy, generosity, perceptions of corruption, freedom to make life choices

SELECT SUM(social_Support),(healthy_life_expectancy),(generosity),(perceptions_of_corruption),(freedom_to_make_life_choices)
FROM happiness_nineteen;

SELECT SUM(social_Support),(healthy_life_expectancy),(generosity),(perceptions_of_corruption),(freedom_to_make_life_choices)
FROM happiness_twenty;

-- Find the average of social_support, healthy life expectancy, generosity, perceptions of corruption, freedom to make life choices from happiness19 and 20

SELECT AVG(social_Support),(healthy_life_expectancy),(generosity),(perceptions_of_corruption),(freedom_to_make_life_choices)
FROM happiness_nineteen;

SELECT AVG(social_Support),(healthy_life_expectancy),(generosity),(perceptions_of_corruption),(freedom_to_make_life_choices)
FROM happiness_twenty;

-- what is the average score of each happiness marker by region

SELECT regional_indicator, AVG(social_Support), AVG(healthy_life_expectancy), AVG(generosity), AVG(perceptions_of_corruption), AVG(freedom_to_make_life_choices)
FROM project.happiness_twenty
GROUP BY regional_indicator;

-- Top 10 Countries with highest scores 

SELECT * FROM project.happiness_nineteen
ORDER BY Score DESC
LIMIT 10;

-- Bottom 10 Countries with lowest scores

SELECT * FROM project.happiness_nineteen
ORDER BY Score ASC
LIMIT 10;

-- Create conditions based on freedom to make choices

SELECT country_name, freedom_to_make_life_choices, CASE
WHEN freedom_to_make_life_choices < 0.25 THEN 'Less than 0.25' 
WHEN freedom_to_make_life_choices > 0.5 THEN 'Greater than 0.5'
ELSE 'Between 0.25 & 0.5' END AS 'freedom to make life choices Range'
FROM project.happiness_nineteen;

-- Lets combine our datasets together based on Country

SELECT * FROM project.happiness_nineteen h19
INNER JOIN project.happiness_twenty h20
ON h19.country_name = h20.country_name;

SELECT h19.country_name, h20.regional_indicator,h19.perceptions_of_corruption,h20.generosity, h20.healthy_life_expectancy,h20.freedom_to_make_life_choices,h20.social_support
FROM project.happiness_nineteen h19
INNER JOIN project.happiness_twenty h20
ON h19.country_name = h20.country_name;

SELECT h19.country_name, h20.regional_indicator,h19.perceptions_of_corruption,h20.generosity, h20.healthy_life_expectancy,h20.freedom_to_make_life_choices,h20.social_support
FROM project.happiness_nineteen h19
INNER JOIN project.happiness_twenty h20
ON h19.country_name = h20.country_name
WHERE h19.country_name = 'United Kingdom';

-- Top 10

SELECT h19.country_name, h20.regional_indicator,h19.perceptions_of_corruption,h20.generosity, h20.healthy_life_expectancy,h20.freedom_to_make_life_choices,h20.social_support
FROM project.happiness_nineteen h19
INNER JOIN project.happiness_twenty h20
ON h19.country_name = h20.country_name
ORDER BY Score DESC
LIMIT 10;

-- BOTTOM 10

SELECT h19.country_name, h20.regional_indicator,h19.perceptions_of_corruption,h20.generosity, h20.healthy_life_expectancy,h20.freedom_to_make_life_choices,h20.social_support
FROM project.happiness_nineteen h19
INNER JOIN project.happiness_twenty h20
ON h19.country_name = h20.country_name
ORDER BY Score ASC
LIMIT 10;

-- AVEREAGE HAPPINESS CRITERIA BASED ON REGIONAL INDICATOR

SELECT h20.regional_indicator,AVG(h19.perceptions_of_corruption), AVG(h20.generosity), AVG(h20.healthy_life_expectancy), AVG(h20.freedom_to_make_life_choices), AVG(h20.social_support)
FROM project.happiness_nineteen h19
INNER JOIN project.happiness_twenty h20
ON h19.country_name = h20.country_name
GROUP BY regional_indicator;

-- Filter country with the highest life expectancy

SELECT h19.country_name, ROUND(h20.healthy_life_expectancy,3)
FROM project.happiness_nineteen h19
INNER JOIN project.happiness_twenty h20
ON h19.country_name = h20.country_name
ORDER BY Score DESC
LIMIT 10;

-- BOTTOM 10

SELECT h19.country_name, ROUND(h20.healthy_life_expectancy,3)
FROM project.happiness_nineteen h19
INNER JOIN project.happiness_twenty h20
ON h19.country_name = h20.country_name
ORDER BY Score ASC
LIMIT 10;

-- Count number of countries per region in dataset
SELECT h20.regional_indicator, COUNT(h19.country_name),h19.perceptions_of_corruption,h20.generosity, h20.healthy_life_expectancy,h20.freedom_to_make_life_choices,h20.social_support
FROM project.happiness_nineteen h19
INNER JOIN project.happiness_twenty h20
ON h19.country_name = h20.country_name
GROUP BY 1
ORDER BY 2 DESC;


-- Filter average healthy life expectancy for Sub-Saharan Africa

SELECT h20.regional_indicator, AVG(h20.healthy_life_expectancy)
FROM project.happiness_nineteen h19
INNER JOIN project.happiness_twenty h20
ON h19.country_name = h20.country_name
WHERE h20.regional_indicator = 'Sub-Saharan africa'
GROUP BY regional_indicator;
-- Compare each regions perception of corruption by each year

SELECT h20.regional_indicator,AVG(h19.perceptions_of_corruption), AVG(h20.perceptions_of_corruption),AVG(h19.generosity), AVG(h20.generosity), AVG(h19.healthy_life_expectancy), AVG(h20.healthy_life_expectancy), AVG(h19.freedom_to_make_life_choices), AVG(h20.freedom_to_make_life_choices), AVG(h19.social_support), AVG(h20.social_support)
FROM project.happiness_nineteen h19
INNER JOIN project.happiness_twenty h20
ON h19.country_name = h20.country_name
GROUP BY regional_indicator;

-- What is the most important variable that affects happiness in each region
SELECT h19.country_name, h20.regional_indicator, h19.gdp_per_capita, h20.Ladder_score,
-- when happiness score is less than average AND gdp per capita is greater than average then Not happy
CASE WHEN h20.Ladder_score < (SELECT avg(Ladder_score) FROM project.happiness_twenty) AND 
h19.gdp_per_capita > (SELECT avg(gdp_per_capita) FROM project.happiness_nineteen) THEN 'Not Happy'
-- when happiness score is more than average AND gdp per capita is less than average then  happy
WHEN h20.Ladder_score > (SELECT avg(Ladder_score) FROM project.happiness_twenty) AND 
h19.gdp_per_capita < (SELECT avg(gdp_per_capita) FROM project.happiness_nineteen) THEN 'Happy'
ELSE 'Neutral'
END AS 'Happiness Value', 

ROUND((SELECT avg(Ladder_score) FROM project.happiness_twenty),0) AS LadderScoreAvgSize,

ROUND((SELECT avg(gdp_per_capita) FROM project.happiness_nineteen),2) AS GdpPerCapitaAvg

FROM project.happiness_nineteen h19
INNER JOIN project.happiness_twenty h20
ON h19.country_name = h20.country_name
GROUP BY regional_indicator;