-- =========================================================
-- Projet Hadoop - Partie 4 : Analyse Hive
-- Dataset : US Accidents (USA.csv)
-- Stockage : HDFS
-- =========================================================

-- ---------------------------------------------------------
-- 1) Base de données
-- ---------------------------------------------------------
CREATE DATABASE IF NOT EXISTS us_accidents;
USE us_accidents;

-- ---------------------------------------------------------
-- 2) Table externe Hive (CSV robuste)
-- ---------------------------------------------------------
DROP TABLE IF EXISTS accidents_raw;

CREATE EXTERNAL TABLE accidents_raw (
  ID STRING,
  Source STRING,
  Severity INT,
  Start_Time STRING,
  End_Time STRING,
  Start_Lat DOUBLE,
  Start_Lng DOUBLE,
  End_Lat DOUBLE,
  End_Lng DOUBLE,
  Distance_mi DOUBLE,
  Description STRING,
  Street STRING,
  City STRING,
  County STRING,
  State STRING,
  Zipcode STRING,
  Country STRING,
  Timezone STRING,
  Airport_Code STRING,
  Weather_Timestamp STRING,
  Temperature_F DOUBLE,
  Wind_Chill_F DOUBLE,
  Humidity DOUBLE,
  Pressure DOUBLE,
  Visibility DOUBLE,
  Wind_Direction STRING,
  Wind_Speed_mph DOUBLE,
  Precipitation DOUBLE,
  Weather_Condition STRING,
  Amenity BOOLEAN,
  Bump BOOLEAN,
  Crossing BOOLEAN,
  Give_Way BOOLEAN,
  Junction BOOLEAN,
  No_Exit BOOLEAN,
  Railway BOOLEAN,
  Roundabout BOOLEAN,
  Station BOOLEAN,
  Stop BOOLEAN,
  Traffic_Calming BOOLEAN,
  Traffic_Signal BOOLEAN,
  Turning_Loop BOOLEAN,
  Sunrise_Sunset STRING,
  Civil_Twilight STRING,
  Nautical_Twilight STRING,
  Astronomical_Twilight STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  "separatorChar" = ",",
  "quoteChar"     = "\"",
  "escapeChar"    = "\\"
)
STORED AS TEXTFILE
LOCATION '/user/cloudera/us_accidents/input'
TBLPROPERTIES ("skip.header.line.count"="1");

-- ---------------------------------------------------------
-- 3) Requêtes analytiques
-- ---------------------------------------------------------

-- Q1 : Nombre d'accidents par État
SELECT State, COUNT(*) AS nb_accidents
FROM accidents_raw
WHERE State IS NOT NULL AND State != ''
GROUP BY State
ORDER BY nb_accidents DESC
LIMIT 20;

-- Q2 : Gravité moyenne par État
SELECT State, ROUND(AVG(Severity), 2) AS avg_severity, COUNT(*) AS nb_accidents
FROM accidents_raw
WHERE State IS NOT NULL AND State != ''
GROUP BY State
ORDER BY avg_severity DESC
LIMIT 20;

-- Q3 : Nombre d'accidents par mois
SELECT SUBSTR(Start_Time, 1, 7) AS year_month, COUNT(*) AS nb_accidents
FROM accidents_raw
WHERE Start_Time IS NOT NULL AND Start_Time != ''
GROUP BY SUBSTR(Start_Time, 1, 7)
ORDER BY year_month;

-- Q4 : Top 20 des conditions météo les plus fréquentes
SELECT Weather_Condition, COUNT(*) AS nb_accidents
FROM accidents_raw
WHERE Weather_Condition IS NOT NULL AND Weather_Condition != ''
GROUP BY Weather_Condition
ORDER BY nb_accidents DESC
LIMIT 20;

-- ---------------------------------------------------------
-- 4) Export des résultats vers HDFS (livrable + démo)
-- ---------------------------------------------------------

-- Export 1 : Accidents par État
INSERT OVERWRITE DIRECTORY '/user/cloudera/us_accidents/hive_results/state_counts'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
SELECT State, COUNT(*) AS nb_accidents
FROM accidents_raw
WHERE State IS NOT NULL AND State != ''
GROUP BY State
ORDER BY nb_accidents DESC;

-- Export 2 : Gravité moyenne par État
INSERT OVERWRITE DIRECTORY '/user/cloudera/us_accidents/hive_results/state_severity_avg'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
SELECT State, ROUND(AVG(Severity), 2) AS avg_severity
FROM accidents_raw
WHERE State IS NOT NULL AND State != ''
GROUP BY State
ORDER BY avg_severity DESC;

-- Export 3 : Accidents par mois
INSERT OVERWRITE DIRECTORY '/user/cloudera/us_accidents/hive_results/monthly_counts'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
SELECT SUBSTR(Start_Time, 1, 7) AS year_month, COUNT(*) AS nb_accidents
FROM accidents_raw
WHERE Start_Time IS NOT NULL AND Start_Time != ''
GROUP BY SUBSTR(Start_Time, 1, 7)
ORDER BY year_month;
