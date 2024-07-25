-- Inspecting the dataset
SELECT * 
FROM Carbon_Emission;

-- Checking for null values in the 'CO2_emission_estimates' column
SELECT * 
FROM Carbon_Emission
WHERE CO2_emission_estimates IS NULL;

-- Checking for null values in the 'Year' column
SELECT * 
FROM Carbon_Emission
WHERE Year IS NULL;

-- Checking for null values in the 'Series' column
SELECT * 
FROM Carbon_Emission
WHERE Series IS NULL;

-- Checking for null values in the 'Value' column
SELECT * 
FROM Carbon_Emission
WHERE Value IS NULL;

-- Ensure no null values are present, then examine specific parts of the dataset

-- Retrieve distinct values in the 'Series' column
SELECT DISTINCT Series
FROM Carbon_Emission;

-- Find the range of years in the dataset
SELECT MIN(Year), MAX(Year)
FROM Carbon_Emission;

-- Find the range of values for 'Emissions (thousand metric tons of carbon dioxide)'
SELECT MIN(Value), MAX(Value)
FROM Carbon_Emission
WHERE Series = 'Emissions (thousand metric tons of carbon dioxide)';

-- Find the range of values for 'Emissions per capita (metric tons of carbon dioxide)'
SELECT MIN(Value), MAX(Value)
FROM Carbon_Emission
WHERE Series = 'Emissions per capita (metric tons of carbon dioxide)';

-- Separate the two distinct 'Series' values into different tables for easier analysis

-- Create 'emissions' table for 'Emissions (thousand metric tons of carbon dioxide)'
CREATE TABLE emissions
(Country nvarchar(50),
 Year int, 
 Series nvarchar(100), 
 Value float);

-- Insert values into the 'emissions' table
INSERT INTO emissions
SELECT * 
FROM Carbon_Emission
WHERE Series = 'Emissions (thousand metric tons of carbon dioxide)';

-- Verify the 'emissions' table
SELECT * 
FROM emissions;

-- Create 'perCapital' table for 'Emissions per capita (metric tons of carbon dioxide)'
CREATE TABLE perCapital
(Country nvarchar(50),
 Year int, 
 Series nvarchar(100), 
 Value float);

-- Insert values into the 'perCapital' table
INSERT INTO perCapital
SELECT * 
FROM Carbon_Emission
WHERE Series = 'Emissions per capita (metric tons of carbon dioxide)';

-- Verify the 'perCapital' table
SELECT * 
FROM perCapital;

-- Find min and max values of carbon emissions per capita in India
SELECT MIN(Value) AS min_value, MAX(Value) AS max_value 
FROM perCapital
WHERE Country = 'India';

-- Find the years corresponding to the min and max values in India
SELECT Year
FROM perCapital
WHERE Country = 'India'
AND Value IN (1.614, 0.35);

-- Compare changes in emissions per capita between 1975 and 2017
WITH value1975 AS 
(SELECT Country, Value AS old_value
 FROM perCapital
 WHERE Year = 1975), 
value2017 AS 
(SELECT Country, Value AS new_value 
 FROM perCapital
 WHERE Year = 2017)

SELECT DISTINCT perCapital.Country, 
       ROUND((value2017.new_value - value1975.old_value)/value1975.old_value, 2) AS changes 
FROM value1975
INNER JOIN value2017 ON value1975.Country = value2017.Country
INNER JOIN perCapital ON value1975.Country = perCapital.Country
ORDER BY changes DESC;

-- Oman has the highest rate of increase (16.25), and Dem. People's Rep. Korea has the lowest rate of decrease (-0.84)

-- Explore the 'emissions' table

-- Verify the 'emissions' table
SELECT * 
FROM emissions;

-- Find the min and max values for India
SELECT MAX(Value), MIN(Value)
FROM emissions
WHERE Country = 'India';

-- Find the years corresponding to the min and max values in India
SELECT * 
FROM emissions
WHERE Value = 2161567.072 OR Value = 217193.593;

-- Identify the top 5 countries with the highest carbon emissions
SELECT TOP 5 Country, SUM(Value) AS sum_value
FROM emissions
GROUP BY Country
ORDER BY sum_value DESC;

-- China, USA, India, Russia, and Japan have the highest carbon emissions
```
