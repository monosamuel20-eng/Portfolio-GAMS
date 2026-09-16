-- EXPLORATORY DATA ANALYSIS
-- Who are the borrowers → How much credit do they take → Why do they borrow 
-- What financial characteristics do they have → Which borrower segments appear financially more exposed?

-- Overall Credit Portfolio Summary
-- What does the overall credit portfolio look like?
SELECT 
    COUNT(*) AS total_borrowers,
    ROUND(AVG(Age), 2) AS average_age,
    MIN(Age) AS minimum_age,
    MAX(Age) AS maximum_age,
    ROUND(AVG(`Credit amount`), 2) AS average_credit_amount,
    MIN(`Credit amount`) AS minimum_credit_amount,
    MAX(`Credit amount`) AS maximum_credit_amount,
    ROUND(AVG(Duration), 2) AS average_duration_months,
    MIN(Duration) AS minimum_duration_months,
    MAX(Duration) AS maximum_duration_months
FROM g_credit_data;

-- Borrower Demographic Profile
SELECT 
    Sex,
    COUNT(*) AS total_borrowers,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM g_credit_data),
        2
    ) AS percentage_of_borrowers,
    ROUND(AVG(Age), 2) AS average_age,
    ROUND(AVG(`Credit amount`), 2) AS average_credit_amount
FROM g_credit_data
GROUP BY Sex
ORDER BY total_borrowers DESC;

-- Age Distribution
SELECT 
    CASE
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS age_group,
    
    COUNT(*) AS total_borrowers,
    
    ROUND(
        AVG(`Credit amount`),
        2
    ) AS average_credit_amount,
    
    ROUND(
        AVG(Duration),
        2
    ) AS average_duration_months

FROM g_credit_data

GROUP BY age_group

ORDER BY age_group;

-- Credit Amount Analysis
-- Which borrower groups receive the largest amounts of credit?
SELECT 
    Job,
    COUNT(*) AS total_borrowers,
    ROUND(AVG(`Credit amount`), 2) AS average_credit_amount,
    SUM(`Credit amount`) AS total_credit_exposure,
    ROUND(AVG(Duration), 2) AS average_duration_months
FROM g_credit_data
GROUP BY Job
ORDER BY average_credit_amount DESC;

-- Credit Purpose Analysis
SELECT 
    Purpose,
    COUNT(*) AS total_loans,
    
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM g_credit_data),
        2
    ) AS percentage_of_loans,
    
    SUM(`Credit amount`) AS total_credit_amount,
    
    ROUND(
        AVG(`Credit amount`),
        2
    ) AS average_credit_amount,
    
    ROUND(
        AVG(Duration),
        2
    ) AS average_duration_months

FROM g_credit_data

GROUP BY Purpose

ORDER BY total_credit_amount DESC;


-- Housing Profile and Credit Behavior
-- Does housing status relate to differences in borrowing behavior?
SELECT 
    Housing,
    COUNT(*) AS total_borrowers,
    
    ROUND(AVG(Age), 2) AS average_age,
    
    ROUND(
        AVG(`Credit amount`),
        2
    ) AS average_credit_amount,
    
    ROUND(
        AVG(Duration),
        2
    ) AS average_duration_months

FROM g_credit_data

GROUP BY Housing

ORDER BY average_credit_amount DESC;

-- Savings Account Analysis
-- How does a borrower's savings level relate to credit amount and loan duration?
SELECT 
    `Saving accounts` AS savings_level,
    
    COUNT(*) AS total_borrowers,
    
    ROUND(
        AVG(`Credit amount`),
        2
    ) AS average_credit_amount,
    
    ROUND(
        AVG(Duration),
        2
    ) AS average_duration_months,
    
    ROUND(
        AVG(Age),
        2
    ) AS average_age

FROM g_credit_data

GROUP BY `Saving accounts`

ORDER BY average_credit_amount DESC;

-- Checking Account Analysis
-- How does checking account status relate to borrowing patterns?
SELECT 
    `Checking account` AS checking_level,
    
    COUNT(*) AS total_borrowers,
    
    ROUND(
        AVG(`Credit amount`),
        2
    ) AS average_credit_amount,
    
    ROUND(
        AVG(Duration),
        2
    ) AS average_duration_months,
    
    ROUND(
        AVG(Age),
        2
    ) AS average_age

FROM g_credit_data

GROUP BY `Checking account`

ORDER BY average_credit_amount DESC;

-- Combined Financial Profile
SELECT 
    `Saving accounts` AS savings_level,
    `Checking account` AS checking_level,
    
    COUNT(*) AS total_borrowers,
    
    ROUND(
        AVG(`Credit amount`),
        2
    ) AS average_credit_amount,
    
    ROUND(
        AVG(Duration),
        2
    ) AS average_duration_months

FROM g_credit_data

GROUP BY 
    `Saving accounts`,
    `Checking account`

HAVING COUNT(*) >= 5

ORDER BY average_credit_amount DESC;

-- Credit Amount Segmentation
-- What does the distribution of credit exposure look like across borrowers?
SELECT 
    CASE
        WHEN `Credit amount` < 2000 THEN 'Low Credit (< 2,000)'
        WHEN `Credit amount` BETWEEN 2000 AND 5000 
            THEN 'Medium Credit (2,000-5,000)'
        WHEN `Credit amount` BETWEEN 5001 AND 10000 
            THEN 'High Credit (5,001-10,000)'
        ELSE 'Very High Credit (10,000+)'
    END AS credit_segment,
    
    COUNT(*) AS total_borrowers,
    
    ROUND(
        AVG(Duration),
        2
    ) AS average_duration_months,
    
    ROUND(
        AVG(Age),
        2
    ) AS average_age

FROM g_credit_data

GROUP BY credit_segment

ORDER BY 
    CASE
        WHEN credit_segment = 'Low Credit (< 2,000)' THEN 1
        WHEN credit_segment = 'Medium Credit (2,000-5,000)' THEN 2
        WHEN credit_segment = 'High Credit (5,001-10,000)' THEN 3
        ELSE 4
    END;
    
    -- Loan Duration Analysis
    SELECT 
    Purpose,
    COUNT(*) AS total_loans,
    
    ROUND(
        AVG(Duration),
        2
    ) AS average_duration_months,
    
    MIN(Duration) AS shortest_duration,
    MAX(Duration) AS longest_duration,
    
    ROUND(
        AVG(`Credit amount`),
        2
    ) AS average_credit_amount

FROM g_credit_data

GROUP BY Purpose

ORDER BY average_duration_months DESC;

-- Age and Borrowing Behavior
SELECT 
    CASE
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS age_group,
    
    COUNT(*) AS total_borrowers,
    
    ROUND(
        AVG(`Credit amount`),
        2
    ) AS average_credit_amount,
    
    ROUND(
        AVG(Duration),
        2
    ) AS average_duration_months

FROM g_credit_data

GROUP BY age_group

ORDER BY age_group;

-- Job and Housing Segmentation
-- Which employment and housing groups have the highest average credit exposure?

SELECT 
    Job,
    Housing,
    
    COUNT(*) AS total_borrowers,
    
    ROUND(
        AVG(`Credit amount`),
        2
    ) AS average_credit_amount,
    
    ROUND(
        AVG(Duration),
        2
    ) AS average_duration_months

FROM g_credit_data

GROUP BY 
    Job,
    Housing

HAVING COUNT(*) >= 5

ORDER BY average_credit_amount DESC;

-- Create a Borrowing Exposure Index
SELECT 
    borrower_group,
    COUNT(*) AS total_borrowers,
    ROUND(AVG(credit_per_month), 2) AS avg_credit_per_month
FROM (
    
    SELECT
        CASE
            WHEN Age < 25 THEN 'Under 25'
            WHEN Age BETWEEN 25 AND 34 THEN '25-34'
            WHEN Age BETWEEN 35 AND 44 THEN '35-44'
            WHEN Age BETWEEN 45 AND 54 THEN '45-54'
            ELSE '55+'
        END AS borrower_group,
        
        `Credit amount` / NULLIF(Duration, 0) AS credit_per_month
        
    FROM g_credit_data
    
) AS credit_analysis

GROUP BY borrower_group

ORDER BY avg_credit_per_month DESC;

-- Identify Potentially High-Exposure Borrowers
SELECT 
    CASE
        WHEN `Credit amount` >= 10000 
             AND Duration >= 36 
        THEN 'High Exposure'
        
        WHEN `Credit amount` >= 5000 
             OR Duration >= 24 
        THEN 'Moderate Exposure'
        
        ELSE 'Lower Exposure'
    END AS exposure_segment,
    
    COUNT(*) AS total_borrowers,
    
    ROUND(
        AVG(`Credit amount`),
        2
    ) AS average_credit_amount,
    
    ROUND(
        AVG(Duration),
        2
    ) AS average_duration_months

FROM g_credit_data

GROUP BY exposure_segment

ORDER BY 
    CASE
        WHEN exposure_segment = 'High Exposure' THEN 1
        WHEN exposure_segment = 'Moderate Exposure' THEN 2
        ELSE 3
    END;
    
    -- Final Executive Summary Query
    SELECT
    COUNT(*) AS total_borrowers,
    
    ROUND(AVG(Age), 2) AS average_borrower_age,
    
    SUM(`Credit amount`) AS total_credit_portfolio,
    
    ROUND(
        AVG(`Credit amount`),
        2
    ) AS average_credit_amount,
    
    ROUND(
        AVG(Duration),
        2
    ) AS average_loan_duration,
    
    COUNT(DISTINCT Purpose) AS number_of_credit_purposes,
    
    COUNT(DISTINCT Housing) AS housing_categories,
    
    COUNT(DISTINCT `Saving accounts`) AS savings_categories

FROM g_credit_data;
