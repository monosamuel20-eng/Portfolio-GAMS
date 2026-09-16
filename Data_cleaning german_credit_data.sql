SELECT *
FROM german_credit_data;

CREATE TABLE g_credit_data
LIKE german_credit_data;

insert g_credit_data
SELECT *
FROM german_credit_data;

SELECT *
FROM g_credit_data;

SET SQL_SAFE_UPDATES = 0;

DESCRIBE g_credit_data;

SELECT COUNT(*) AS total_rows
FROM g_credit_data;

SELECT
    COUNT(*) AS total_rows,
    SUM(Age IS NULL) AS missing_age,
    SUM(Sex IS NULL) AS missing_sex,
    SUM(Job IS NULL) AS missing_job,
    SUM(Housing IS NULL) AS missing_housing,
    SUM(`Saving accounts` IS NULL) AS missing_saving_accounts,
    SUM(`Checking account` IS NULL) AS missing_checking_account,
    SUM(`Credit amount` IS NULL) AS missing_credit_amount,
    SUM(Duration IS NULL) AS missing_duration,
    SUM(Purpose IS NULL) AS missing_purpose
FROM g_credit_data;

SELECT
    MIN(Age) AS youngest,
    MAX(Age) AS oldest,
    AVG(Age) AS average_age,
    MIN(`Credit amount`) AS minimum_credit,
    MAX(`Credit amount`) AS maximum_credit,
    AVG(`Credit amount`) AS average_credit,
    MIN(Duration) AS shortest_duration,
    MAX(Duration) AS longest_duration
FROM g_credit_data;

SELECT
    Sex,
    COUNT(*) AS total
FROM g_credit_data
GROUP BY Sex;

SELECT
    Housing,
    COUNT(*) AS total
FROM g_credit_data
GROUP BY Housing;

SELECT
    `Saving accounts`,
    COUNT(*) AS total
FROM g_credit_data
GROUP BY `Saving accounts`;


SELECT 
    COUNT(*) AS null_values
FROM g_credit_data
WHERE `Saving accounts` IS NULL;

UPDATE g_credit_data
SET `Saving accounts` = 'Unknown'
WHERE `Saving accounts` = 'NA';

