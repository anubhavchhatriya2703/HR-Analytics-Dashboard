USE projects;

SELECT * FROM hr;

DESCRIBE hr;

SET SQL_SAFE_UPDATES = 0;

-- Convert birthdate
UPDATE hr
SET birthdate = CASE
    WHEN birthdate LIKE '%/%'
        THEN DATE_FORMAT(STR_TO_DATE(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
    WHEN birthdate REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
        THEN DATE_FORMAT(STR_TO_DATE(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
    WHEN birthdate REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
        THEN birthdate
    ELSE NULL
END;

ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

-- Convert hire_date
UPDATE hr
SET hire_date = CASE
    WHEN hire_date LIKE '%/%'
        THEN DATE_FORMAT(STR_TO_DATE(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
    WHEN hire_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
        THEN DATE_FORMAT(STR_TO_DATE(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
    WHEN hire_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
        THEN hire_date
    ELSE NULL
END;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

-- Convert termdate
UPDATE hr
SET termdate = CASE
    WHEN termdate REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} UTC$'
        THEN DATE(STR_TO_DATE(termdate,'%Y-%m-%d %H:%i:%s UTC'))
    WHEN termdate REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
        THEN termdate
    ELSE NULL
END;

ALTER TABLE hr
MODIFY COLUMN termdate DATE;

-- Add age column ONLY if it doesn't exist

-- Calculate age
UPDATE hr
SET age = TIMESTAMPDIFF(YEAR,birthdate,CURDATE());

-- Youngest & oldest
SELECT
    MIN(age) AS youngest,
    MAX(age) AS oldest
FROM hr;

-- Employees under 18
SELECT COUNT(*) AS under_18
FROM hr
WHERE age < 18;

-- Future termination dates
SELECT COUNT(*) AS future_termination
FROM hr
WHERE termdate > CURDATE();

-- Active employees
SELECT COUNT(*) AS active_employees
FROM hr
WHERE termdate IS NULL;

-- Locations
SELECT DISTINCT location
FROM hr;