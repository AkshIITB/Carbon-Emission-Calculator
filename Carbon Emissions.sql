SELECT * FROM carbon_emissions.`carbon dioxide emission estimates`;

-- then, I check if there are any columns that have null values. 


SELECT * 
FROM carbon_emissions.`carbon dioxide emission estimates`
WHERE `CO2 emission estimates` IS NULL;

SELECT * 
FROM carbon_emissions.`carbon dioxide emission estimates`
WHERE Year IS NULL;

SELECT * 
FROM carbon_emissions.`carbon dioxide emission estimates`
WHERE Series IS NULL;

SELECT * 
FROM carbon_emissions.`carbon dioxide emission estimates`
WHERE Value IS NULL;

-- after making sure that there are no nulls in my dataset, I move to exam the smaller parts of my dataset
-- including the range of the column "Year", distinct value of the column "Series", the range of the column "Value" 
-- with different conditions. 

SELECT DISTINCT Series
FROM carbon_emissions.`carbon dioxide emission estimates`;

SELECT MIN(Year), MAX(Year)
FROM carbon_emissions.`carbon dioxide emission estimates`;

SELECT MIN(Value), MAX(Value)
FROM carbon_emissions.`carbon dioxide emission estimates`
WHERE Series = 'Emissions (thousand metric tons of carbon dioxide)';

SELECT MIN(Value), MAX(Value)
FROM carbon_emissions.`carbon dioxide emission estimates`
WHERE Series = 'Emissions per capita (metric tons of carbon dioxide)';

-- after checking some smaller parts of my dataset, I find out that the 'Series' column has 2 distinct values.
-- I decide to break these two values into two different tables so that I can work with them easier. 

-- firstly, I creat a new table called 'emissions' for the series 'Emissions (thousand metric tons of carbon dioxide)'

CREATE TABLE emissions
(Country nvarchar(50),
Year int, 
Series nvarchar(100), 
Value float)

-- I insert values from the 'Carbon_Emission' table where Series = 'Emissions (thousand metric tons of carbon dioxide)'
-- into the 'emissions' table that I just create.

INSERT INTO emissions
SELECT * FROM carbon_emissions.`carbon dioxide emission estimates`
WHERE Series = 'Emissions (thousand metric tons of carbon dioxide)'

SELECT * 
FROM emissions

-- Next, I creat a new table called 'perCapital' for the series Emissions per capita (metric tons of carbon dioxide) --- 
CREATE TABLE perCapital
(Country nvarchar(50),
Year int, 
Series nvarchar(100), 
Value float)

-- I insert values from the 'Carbon_Emission' table where Series = 'Emissions per capita (metric tons of carbon dioxide)'
-- into the 'perCapital' table that I just create

INSERT INTO perCapital
SELECT * FROM carbon_emissions.`carbon dioxide emission estimates`
WHERE Series = 'Emissions per capita (metric tons of carbon dioxide)'

--Now, I'm going to explore the perCapital table first 

SELECT * 
FROM perCapital

-- I want to find the data about only America. 

SELECT DISTINCT Country
FROM perCapital
WHERE COUNTRY LIKE 'U%' -- find countries that start with the letter U since there are many names for America, I'm not sure
-- which one is used in my dataset. 

-- next, I find the min and max value of Carbon Emissions per capital in America

SELECT MIN(Value) as min_value, MAX(Value) as Max_value 
FROM perCapital
WHERE Country = 'United States of America';
--- The min value is 14.606 and the max value is 20.168

SELECT Year
FROM perCapital
WHERE Country = 'United States of America'
AND Value IN (20.168, 14.606);
--- the year for the max value is 1975 and the year for the min value is 2017. 

-- next, I wanted to know the changes of emissions per capital in 2017 compared to the changes of emissions per capital in 1975 --- 
WITH value1975 AS (
    SELECT Country, Value AS old_value
    FROM perCapital
    WHERE Year = 1975
)
SELECT *
FROM value1975;

WITH value2017 AS 
(SELECT Country, Value as new_value 
FROM perCapital
WHERE Year = 2017)
SELECT * FROM value2017

SELECT DISTINCT perCapital.Country, 
       ROUND((value2017.new_value - value1975.old_value)/value1975.old_value,2) AS changes 
FROM 
  (SELECT Country, Value AS old_value
   FROM perCapital
   WHERE Year = 1975) AS value1975
INNER JOIN 
  (SELECT Country, Value AS new_value 
   FROM perCapital
   WHERE Year = 2017) AS value2017 
ON value1975.Country = value2017.Country
INNER JOIN perCapital ON value1975.Country = perCapital.Country
ORDER BY changes DESC;


 
---- Oman is the country that has the highest rate of increasing, which is 16.25. 
--- Dem. People's Rep. Korea has the lowest rate of decreasing, which is -0.84


-- now, I'm going to with the emissions table

SELECT * 
FROM emissions

-- I want want to know the min and max value of America -- 

SELECT * 
FROM emissions
WHERE Country = 'United States of America'

SELECT MAX(Value), Min(Value)
FROM emissions
WHERE Country = 'United States of America'

SELECT * 
FROM emissions
WHERE Value = 5703220.175 -- 2005 
OR Value = 4355839.181 -- 1975

-- finally, I want to find out which 5 countries have the highest amount of carbon emissions. 

SELECT Country, SUM(Value) AS sum_value
FROM emissions
GROUP BY Country
ORDER BY sum_value DESC
LIMIT 5;


