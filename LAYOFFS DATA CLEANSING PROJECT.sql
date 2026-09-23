-- DATA CLEANING

select *
from layoffs;

-- 1. REMOVE DUPLICATES
-- 2. STANDARDIZE THE DATA
-- 3. NULL VALUES OR BLANK
-- 4. REMOVE ANY COLUMNS


-- 1. REMOVE DUPLICATES
CREATE TABLE LAYOFFS_STAGING 
LIKE LAYOFFS;

select *
from layoffs_STAGING;

INSERT LAYOFFS_STAGING
SELECT *
FROM LAYOFFS;

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY COMPANY, INDUSTRY, TOTAL_LAID_OFF, PERCENTAGE, `DATE`) AS ROW_NUM
FROM layoffs_staging;

WITH DUPLICATE_CTE AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY COMPANY, LOCATION, TOTAL_LAID_OFF, `DATE`, PERCENTAGE, INDUSTRY, STAGE, COUNTRY, FUNDS_RAISED) AS ROW_NUM
FROM layoffs_staging
)
SELECT *
FROM DUPLICATE_CTE
WHERE row_num > 1;

SELECT *
FROM layoffs_staging
WHERE COMPANY = '&OPEN';

WITH DUPLICATE_CTE AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY COMPANY, LOCATION, TOTAL_LAID_OFF, `DATE`, PERCENTAGE, INDUSTRY, STAGE, COUNTRY, FUNDS_RAISED) AS ROW_NUM
FROM layoffs_staging
)
DELETE 
FROM DUPLICATE_CTE
WHERE row_num > 1;


CREATE TABLE `layoffs_staging2` (
  `COMPANY` text,
  `LOCATION` text,
  `TOTAL_LAID_OFF` text,
  `DATE` text,
  `PERCENTAGE` text,
  `INDUSTRY` text,
  `STAGE` text,
  `FUNDS_RAISED` text,
  `COUNTRY` text,
  `ROW_NUM` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY COMPANY, LOCATION, TOTAL_LAID_OFF, `DATE`, PERCENTAGE, INDUSTRY, STAGE, COUNTRY, FUNDS_RAISED) AS ROW_NUM
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2
WHERE ROW_NUM > 1;

DELETE
FROM layoffs_staging2
WHERE ROW_NUM > 1;

SELECT *
FROM layoffs_staging2;


-- 2. STANDARDIZE THE DATA

SELECT COMPANY, (TRIM(COMPANY))
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET COMPANY = TRIM(COMPANY);

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;


SELECT LOCATION, (TRIM(LOCATION))
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET LOCATION = TRIM(LOCATION);

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE LOCATION LIKE 'AUCKLAND%';
UPDATE layoffs_staging2
SET LOCATION = 'Auckland, Non-U.S.'
WHERE LOCATION LIKE 'AUCKLAND%' ;

SELECT *
FROM layoffs_staging2
WHERE LOCATION LIKE 'BENGALURU%';
UPDATE layoffs_staging2
SET LOCATION = 'Bengaluru, Non-U.S.'
WHERE LOCATION LIKE 'BENGALURU%';

SELECT *
FROM layoffs_staging2
WHERE location LIKE 'brisbane%';
UPDATE layoffs_staging2
SET LOCATION = 'Brisbane, Non-U.S.'
WHERE LOCATION LIKE 'Brisbane%';

SELECT *
FROM layoffs_staging2
WHERE LOCATION LIKE 'Buenos%';
UPDATE layoffs_staging2
SET LOCATION = 'Buenos Aires, Non-U.S.'
WHERE LOCATION LIKE 'Buenos Aires%';

SELECT *
FROM layoffs_staging2
WHERE LOCATION LIKE 'Cayman%';
UPDATE layoffs_staging2
SET LOCATION = 'Cayman Island, Non-U.S.'
WHERE LOCATION LIKE 'Cayman%';

SELECT *
FROM layoffs_staging2
WHERE LOCATION LIKE 'Gurugram%';
UPDATE layoffs_staging2
SET LOCATION = 'Gurugram, Non-U.S.'
WHERE LOCATION LIKE 'Gurugram%';

SELECT *
FROM layoffs_staging2
WHERE LOCATION LIKE 'Kuala%';
UPDATE layoffs_staging2
SET LOCATION = 'Kuala Lumpur, Non-U.S.'
WHERE LOCATION LIKE 'Kuala%';

SELECT *
FROM layoffs_staging2
WHERE LOCATION LIKE 'Luxembourg%';
UPDATE layoffs_staging2
SET LOCATION = 'Luxembourg, Non-U.S.'
WHERE LOCATION LIKE 'Luxembourg%';

SELECT *
FROM layoffs_staging2
WHERE LOCATION LIKE 'MELBOURNE%';
UPDATE layoffs_staging2
SET LOCATION = 'Melbourne, Non-U.S.'
WHERE LOCATION LIKE 'MELBOURNE%';

SELECT *
FROM layoffs_staging2
WHERE LOCATION LIKE 'Montreal%';
UPDATE layoffs_staging2
SET LOCATION = 'Montreal, Non-U.S.'
WHERE LOCATION LIKE 'Montreal%';

SELECT *
FROM layoffs_staging2
WHERE LOCATION LIKE 'Mumbai%';
UPDATE layoffs_staging2
SET LOCATION = 'Mumbai, Non-U.S.'
WHERE LOCATION LIKE 'Mumbai%';

SELECT *
FROM layoffs_staging2
WHERE LOCATION LIKE '%Delhi%';
UPDATE layoffs_staging2
SET LOCATION = 'Delhi, New York City'
WHERE LOCATION LIKE 'New Delhi, New%';

SELECT *
FROM layoffs_staging2
WHERE LOCATION LIKE 'Singapore%';
UPDATE layoffs_staging2
SET LOCATION = 'Singapore, Non-U.S.'
WHERE LOCATION LIKE 'Singapore%';

SELECT *
FROM layoffs_staging2
WHERE LOCATION LIKE 'Tel Aviv%';
UPDATE layoffs_staging2
SET LOCATION = 'Tel Aviv, Non-U.S.'
WHERE LOCATION LIKE 'Tel Aviv%';

SELECT *
FROM layoffs_staging2
WHERE LOCATION LIKE 'Vancouver%';
UPDATE layoffs_staging2
SET LOCATION = 'Vancouver, Non-U.S.'
WHERE LOCATION LIKE 'Vancouver%';

SELECT DISTINCT COUNTRY
FROM layoffs_staging2
order by 1;

SELECT *
FROM layoffs_staging2
WHERE LOCATION LIKE '%NON%' AND COUNTRY = 'UNITED STATES';

UPDATE layoffs_staging2 T1
JOIN layoffs_staging2 T2
	ON TRIM(LOWER(SUBSTRING_INDEX(T1.LOCATION, ',',1))) = TRIM(LOWER(SUBSTRING_INDEX(T2.LOCATION, ',',1)))
SET T1.COUNTRY = T2.COUNTRY
WHERE LOWER(T1.COUNTRY) LIKE '%UNITED STATES%'
	AND LOWER(T2.COUNTRY) NOT LIKE '%UNITED STATES%'
    AND LOWER(T2.LOCATION) LIKE '%NON-U%S%';
    
UPDATE layoffs_staging2
SET COUNTRY = 'Argentina'
WHERE LOCATION LIKE 'Buenos Aires%';

SELECT
	TRIM(SUBSTRING_INDEX(LOCATION, ',', 1)) AS CITY,
    COUNT(DISTINCT COUNTRY) AS COUNTRY_COUNT_DIFF,
    GROUP_CONCAT(DISTINCT COUNTRY SEPARATOR ',') AS COUNTRY_LIST
FROM LAYOFFS_STAGING2
GROUP BY CITY
HAVING COUNTRY_COUNT_DIFF > 1;

SELECT *
FROM layoffs_staging2
WHERE LOCATION LIKE '%DUBAI%';

WITH COUNTRYCOUNTS AS (
	SELECT TRIM(SUBSTRING_INDEX(LOCATION, ',', 1)) AS CITY,
	COUNTRY, COUNT(*) AS TOTAL_APPEARS, 
    ROW_NUMBER() OVER (
    PARTITION BY TRIM(SUBSTRING_INDEX(LOCATION, ',', 1))
    ORDER BY COUNT(*) DESC ) AS RN
FROM LAYOFFS_STAGING2
WHERE COUNTRY IS NOT NULL AND COUNTRY != ''
GROUP BY TRIM(SUBSTRING_INDEX(LOCATION, ',', 1)), COUNTRY ), 
DOMINANTCOUNTRY AS (
SELECT CITY, COUNTRY AS DOMINANT_COUNTRY
FROM COUNTRYCOUNTS
WHERE RN = 1 
)
UPDATE layoffs_staging2 T
JOIN DOMINANTCOUNTRY D
	ON TRIM(substring_index(T.LOCATION, ',', 1)) = D.CITY
    SET T.COUNTRY = D.DOMINANT_COUNTRY;
    
    
create index idx_staging_comp on layoffs_staging(company(50), location(50));
create index idx_staging2_comp on layoffs_staging2(company(50), location(50));

update layoffs_staging2 t2
join layoffs_staging t1 
	on t2.COMPANY = t1.company 
	and t2.location = t1.location 
set t2.`date` = t1.`date`;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y')
where `date` is not null and `date` != '';

alter table layoffs_staging2
modify column `date` date;


select *
from layoffs_staging2
where TOTAL_LAID_OFF = '' and PERCENTAGE = '';

delete
from layoffs_staging2
where TOTAL_LAID_OFF = '' and PERCENTAGE = '';

select t1.INDUSTRY, t2.INDUSTRY
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.COMPANY = t2.COMPANY
where (t1.INDUSTRY is null or t1.INDUSTRY = '')
and t2.INDUSTRY is not null;


update layoffs_staging2
set PERCENTAGE = null
where PERCENTAGE = '';

update layoffs_staging2
set industry = null
where INDUSTRY = '';

select *
from layoffs_staging2
where INDUSTRY is null;

update layoffs_staging2
set stage = null
where stage = '';

select *
from layoffs_staging2;

UPDATE layoffs_staging2
SET PERCENTAGE = TRIM(TRAILING '.' FROM TRIM(TRAILING '0' FROM PERCENTAGE))
WHERE PERCENTAGE LIKE '%.%';

WITH DUPLICATE_CTE AS (
	SELECT *,
    ROW_NUMBER() OVER(
    PARTITION BY COMPANY, TOTAL_LAID_OFF, `date`, PERCENTAGE
    ORDER BY COMPANY
    ) AS ROW_NUM
    FROM layoffs_staging2)
    SELECT *
    FROM DUPLICATE_CTE 
    WHERE ROW_NUM > 1;
    
    ALTER TABLE layoffs_staging2 ADD COLUMN TEMP_ID INT auto_increment PRIMARY  KEY;
    
WITH DUPLICATE_CTE AS (
	SELECT TEMP_ID,
    ROW_NUMBER() OVER(
    PARTITION BY COMPANY, TOTAL_LAID_OFF, `date`, PERCENTAGE
    ORDER BY TEMP_ID
    ) AS ROW_NUM
    FROM layoffs_staging2)
    DELETE T1
    FROM layoffs_staging2 T1
    JOIN DUPLICATE_CTE T2 ON T1.TEMP_ID = T2.TEMP_ID
    WHERE T2.ROW_NUM > 1;
    ALTER TABLE layoffs_staging2 DROP COLUMN TEMP_ID;
    
    SELECT *
    FROM layoffs_staging2 T1
    JOIN layoffs_staging2 T2
		ON T1.COMPANY = T2.COMPANY
        AND T1.DATE = T2.DATE
        WHERE T1.TOTAL_LAID_OFF IS NULL 
        AND T2.TOTAL_LAID_OFF IS NOT NULL;
        
	DELETE T1
    FROM layoffs_staging2 T1
    JOIN layoffs_staging2 T2
		ON T1.COMPANY = T2.COMPANY
        AND T1.DATE = T2.DATE
        WHERE T1.TOTAL_LAID_OFF IS NULL 
        AND T2.TOTAL_LAID_OFF IS NOT NULL;
    
    SELECT *
    FROM layoffs_staging2;
   
alter table  layoffs_staging2
drop column row_num;