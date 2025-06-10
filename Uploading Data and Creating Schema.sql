CREATE DATABASE Olympics;
USE Olympics;
-- create a staging table to upload the data into to start with
CREATE TABLE `staging` (
  `ID` BIGINT, 
  `Name` VARCHAR(1024), 
  `Sex` VARCHAR(1024), 
  `Age` VARCHAR(1024), 
  `Height` VARCHAR(1024), 
  `Weight` VARCHAR(1024), 
  `Team` VARCHAR(1024), 
  `NOC` VARCHAR(1024), 
  `Games` VARCHAR(1024), 
  `Year` BIGINT, 
  `Season` VARCHAR(1024), 
  `City` VARCHAR(1024), 
  `Sport` VARCHAR(1024), 
  `Event` VARCHAR(1024), 
  `Medal` VARCHAR(1024), 
  `NOC_Region` VARCHAR(1024), 
  `NOC_notes` VARCHAR(1024)
);
-- data then added to staging table here by INSERT INTO `staging` VALUES (...data...) - command deleted due to size after data uploaded
-- now checking column sizes:
SELECT 
  MAX(
    LENGTH(name)
  ), 
  MAX(
    LENGTH(sex)
  ), 
  MAX(
    LENGTH(team)
  ), 
  MAX(
    LENGTH(noc)
  ), 
  MAX(
    LENGTH(noc_region)
  ), 
  MAX(
    LENGTH(NOC_notes)
  ), 
  MAX(
    LENGTH(event)
  ), 
  MAX(
    LENGTH(city)
  ), 
  MAX(
    LENGTH(season)
  ), 
  MAX(
    LENGTH(sport)
  ), 
  MAX(
    LENGTH(games)
  ), 
  MAX(
    LENGTH(medal)
  ) 
FROM 
  olympics.staging;
-- finding data required for teams dimension table, adding a row number :
SELECT 
  DISTINCT team, 
  noc, 
  noc_region, 
  NOC_notes 
FROM 
  staging;
-- using this as a CTE in order to add a row number as an ID:
WITH teams_s1 AS (
  SELECT 
    DISTINCT team, 
    noc, 
    noc_region, 
    NOC_notes 
  FROM 
    staging
) 
SELECT 
  ROW_NUMBER() OVER(
    ORDER BY 
      team
  ) as team_id, 
  team, 
  noc, 
  noc_region, 
  NOC_notes 
FROM 
  teams_s1;
-- now creating the actual dimensions table which will be populated - using the max length of each field from earlier:
CREATE TABLE teams (
  team_id INT, 
  team VARCHAR(47), 
  noc VARCHAR(3), 
  noc_region VARCHAR(32), 
  NOC_notes VARCHAR(27)
);
-- Inserting the data into the table from earlier query. An alternative way to do this is to do CREATE TABLE FROM .. instead of creating an empty table first.
INSERT INTO teams (
  WITH teams_s1 AS (
    SELECT 
      DISTINCT team, 
      noc, 
      noc_region, 
      NOC_notes 
    FROM 
      staging
  ) 
  SELECT 
    ROW_NUMBER() OVER(
      ORDER BY 
        team
    ) as team_id, 
    team, 
    noc, 
    noc_region, 
    NOC_notes 
  FROM 
    teams_s1
);
-- adding a primary key to the teams table
ALTER TABLE 
  teams 
ADD 
  PRIMARY KEY(team_id);
-- now to create the table for athletes, first creating a query to find each individual athlete.
SELECT 
  distinct Name, 
  Sex, 
  NULLIF(height, '') AS height, 
  NULLIF(weight, '') AS weight, 
  ID AS athlete_id 
FROM 
  staging;
-- this uses NULLIF() to replace blanks with null values. Creating the table from this query:
CREATE TABLE athletes (
  athlete_id INT, 
  name VARCHAR(100), 
  sex VARCHAR(1), 
  height INT, 
  weight INT
);
INSERT INTO athletes 
SELECT 
  distinct ID AS athlete_id, 
  Name, 
  Sex, 
  NULLIF(height, '') AS height, 
  NULLIF(weight, '') AS weight 
FROM 
  staging;
-- setting PK for athletes table:
ALTER TABLE 
  athletes 
ADD 
  PRIMARY KEY(athlete_id);
-- repeating the process for games
CREATE TABLE games (
  games_id INT, 
  year INT, 
  games VARCHAR(20), 
  season VARCHAR(6), 
  city VARCHAR(25)
);
WITH games_s1 AS (
  SELECT 
    DISTINCT year, 
    games, 
    season, 
    city 
  FROM 
    staging
) 
SELECT 
  ROW_NUMBER() OVER(
    ORDER BY 
      year, 
      games, 
      season
  ) as games_id, 
  year, 
  games, 
  season, 
  city 
FROM 
  games_s1;
-- and for events
-- and for events:
CREATE TABLE events (
  event_id INT,
  event VARCHAR(100),
  sport VARCHAR(25)
);
INSERT INTO events
WITH events_s1 AS(
SELECT DISTINCT 
	event,
	sport
	FROM staging
    )
SELECT 
  * 
FROM 
  staging;
ROW_NUMBER() OVER(ORDER BY event, sport) as event_id,
event,
sport
FROM events_s1;



-- TBC








