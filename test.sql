-- How many rows are in the names table?
/*
SELECT COUNT(*)
FROM names
*/
-- There are 1957046 rows

--How many total registered people appear in the dataset?
/*
SELECT SUM(num_registered)
FROM names
*/
-- 351653025

-- 3. Which name had the most appearances in a single year in the dataset?

/*
SELECT year, name, SUM(num_registered) AS HowMany
FROM names
GROUP BY year, name
ORDER BY SUM(num_registered) DESC
*/

-- Seems like Linda in 1947 with 99905 Appearances

-- 4. What range of years are included?
/*
SELECT MIN(year), MAX(year) from names
*/
-- 1880 to 2018

--5. What year has the largest number of registrations?
/*
SELECT year, SUM(num_registered) AS HowManyRegistered
FROM names
GROUP BY year
ORDER BY SUM(num_registered) DESC
*/
-- 1957 with 4200022

-- 6. How many different (distinct) names are contained in the dataset?
/*
SELECT COUNT(DISTINCT name)
FROM names
*/
-- 98400

-- 7. Are there more males or more females registered?
/*
SELECT gender, SUM(num_registered) AS HowMany
FROM names
GROUP BY gender
*/
-- F 174079232, M 177573793 More males

--8. What are the most popular male and female names overall (i.e., the most total registrations)?
/*
SELECT name, SUM(num_registered) AS HowMany
FROM names
WHERE gender = 'F'
GROUP BY name
ORDER BY SUM(num_registered) DESC
LIMIT 1
*/
-- Mary 4125675

/*
SELECT name, SUM(num_registered) AS HowMany
FROM names
WHERE gender = 'M'
GROUP BY name
ORDER BY SUM(num_registered) DESC
LIMIT 1
*/
-- James 5164280

--9. What are the most popular boy and girl names of the first decade of the 2000s (2000 - 2009)?
/*
SELECT name, SUM(num_registered) AS HowMany
FROM names
WHERE (gender = 'M' AND year >= 2000 AND year <= 2009)
GROUP BY name
ORDER BY SUM(num_registered) DESC
LIMIT 1
*/
-- Jacob 273844
/*
SELECT name, SUM(num_registered) AS HowMany
FROM names
WHERE (gender = 'F' AND year >= 2000 AND year <= 2009)
GROUP BY name
ORDER BY SUM(num_registered) DESC
LIMIT 1
*/
-- Emily 223690

--10  Which year hd the most variety of names?
/*
SELECT COUNT(DISTINCT name) AS HowManyDistinctNames, year 
FROM names
GROUP BY year
ORDER BY HowManyDistinctNames DESC
LIMIT 1
*/
--2008 with 32518

--11. What is the most popular name for a girl that starts with the letter X?
/*
SELECT name, sum(num_registered) AS HowMany from names
WHERE (name LIKE 'X%' AND gender = 'F')
GROUP BY name
ORDER BY HowMany DESC
LIMIT 1
*/

-- Ximena 26145

--12. How many distinct names appear that start with a 'Q', but whose second letter is not 'u'?
/*
SELECT COUNT(DISTINCT name) from names
WHERE (name LIKE 'Q%' and name NOT LIKE '%u%')
*/
-- 45 

-- 13. Which is the more popular spelling between "Stephen" and "Steven"? Use a single query to answer this question.
/*
SELECT name, SUM(num_registered) as HowMany
FROM names
WHERE (name = 'Stephen' OR name = 'Steven')
GROUP BY name
*/
--Steven with 1286951 and Stephen 860972

-- 14. What percentage of names are "unisex" - that is what percentage of names have been used both for boys and for girls?

/*
WITH NameCounts AS (
  SELECT name, COUNT(DISTINCT gender) AS GenderCount
  FROM names
  GROUP BY name
)

SELECT COUNT(*) AS UnisexNamesCount,
       (COUNT(*) * 100.0 / (SELECT COUNT(DISTINCT name) FROM NameCounts)) AS PercentageUnisex
FROM NameCounts
WHERE GenderCount = 2;
*/
-- 10.9%

--16. How many names have only appeared in one year?
/*
WITH NameYears AS (
SELECT name, COUNT(DISTINCT year) as HowManyYears
FROM names
GROUP BY name
)
SELECT Count(*)
FROM NameYears
WHERE HowManyYears = 1
*/
-- 21123

-- 17. How many names only appeared in the 1950s?
/*
WITH names_50s AS (
  SELECT DISTINCT name
  FROM names
  WHERE year BETWEEN 1950 AND 1959
),
names_not_50s AS (
  SELECT DISTINCT name
  FROM names
  WHERE year NOT BETWEEN 1950 AND 1959
)

SELECT Count(name)
FROM names_50s
WHERE name NOT IN (SELECT name FROM names_not_50s);
*/
-- 661

--18 How many names made their first appearance in the 2010s?
/*
WITH first_appeared_2010 AS (
  SELECT DISTINCT name
  FROM names
  WHERE year >= 2010
),
appeared_before_2010s AS (
  SELECT DISTINCT name
  FROM names
  WHERE year < 2010
)

SELECT COUNT(name)
FROM first_appeared_2010
WHERE name NOT IN (SELECT name FROM appeared_before_2010s)
*/

--11270--

--Find the names that have not be used in the longest.
/*
With LastUsedTable AS (
SELECT DISTINCT name, MAX(year) as LastUsed
from names 
GROUP BY name
ORDER BY LastUsed Asc
)
SELECT * FROM LastUsedTable
Where LastUsed <1890
*/

-----------------BONUS QUESTIONS------------------
/*
Select name, CHAR_LENGTH(name) AS LENGTH
FROM names
GROUP BY name
ORDER BY LENGTH DESC
*/

--How many names are palindromes (i.e. read the same backwards and forwards, such as Bob and Elle)?
/*
SELECT COUNT(DISTINCT name)
FROM names
WHERE REVERSE(LOWER(name)) = LOWER(name)
*/
--137

--3. Find all names that contain no vowels (for this question, we'll count a,e,i,o,u, and y as vowels).
/*
SELECT Count(DISTINCT name)
FROM names
WHERE LOWER(name) NOT LIKE '%a%' 
  AND LOWER(name) NOT LIKE '%e%' 
  AND LOWER(name) NOT LIKE '%i%' 
  AND LOWER(name) NOT LIKE '%o%' 
  AND LOWER(name) NOT LIKE '%u%'
  AND LOWER(name) NOT LIKE '%y%'
 */
/*
SELECT Count(DISTINCT name)
FROM names
WHERE NOT LOWER(name) ~ '[aeiouy]';
*/


-- 4. How many double-letter names show up in the dataset? Double-letter means the same letter repeated back-to-back, like Matthew or Aaron. Are there any triple-letter names?
/*
SELECT COUNT (DISTINCT name)
FROM names
WHERE LOWER(name) ~ '(.)\1'
*/
-- 12 names with triple letters and 22537 names with double letters

/*
5. On question 17 of the first part of the exercise, you found names that only appeared in the 1950s. Now, find all names that did not appear in the 1950s but were used both before and after the 1950s. We'll answer this question in two steps.
	a. First, write a query that returns all names that appeared during the 1950s.
	b. Now, make use of this query along with the IN keyword in order the find all names that did not appear in the 1950s but which were used both before and after the 1950s.
*/

/*
WITH names_50s AS (
  SELECT DISTINCT name
  FROM names
  WHERE year BETWEEN 1950 AND 1959
),
names_not_50s AS (
  SELECT DISTINCT name
  FROM names
  WHERE year NOT BETWEEN 1950 AND 1959
)

SELECT Count(name)
FROM names_not_50s
WHERE name NOT IN (SELECT name FROM names_50s);
*/

--81393

--6. In question 16, you found how many names appeared in only one year. Which year had the highest number of names that only appeared once?

/*
SELECT year, name, COUNT(*) as HowManyTimes
FROM names
GROUP BY year, name
ORDER BY HowManyTimes DESC
*/
/*
WITH NameYearCounts AS (
  SELECT year, name, COUNT(*) AS NameCount
  FROM names
  GROUP BY year, name
)

SELECT year, COUNT(*) AS num_uniques
FROM NameYearCounts
WHERE NameCount = 1
GROUP BY year
ORDER BY num_uniques DESC
*/

-- 7. Which year had the most new names (names that hadn't appeared in any years before that year)? For this question, you might find it useful to write a subquery and then select from this subquery. See this page about using subqueries in the from clause: https://www.geeksforgeeks.org/sql-sub-queries-clause/

/*
SELECT year, COUNT (DISTINCT name)
FROM names n1
WHERE name NOT IN (
	SELECT name 
	FROM names n2
	WHERE n2.year < n1.year
)
GROUP BY n1.year
*/
/*
SELECT year as this_year, COUNT(DISTINCT name)
FROM names n1
WHERE NOT EXISTS (
    SELECT 1
    FROM names n2
    WHERE n2.name = n1.name AND n2.year < n1.year
)
GROUP BY this_year;
*/













	




