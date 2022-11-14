/* The dataset for this exercise has been derived from the `Indeed Data Scientist/Analyst/Engineer` 
   [dataset](https://www.kaggle.com/elroyggj/indeed-dataset-data-scientistanalystengineer) on kaggle.com  

   This script provides SQL queries and answers for the following questions/tasks 
   using a data_analyst_jobs table created in PostgreSQL. */



/* How many rows are in the data_analyst_jobs table?
      ANSWER: 1793. */

SELECT COUNT(*) 
FROM data_analyst_jobs;


/* Look at the first 10 rows. What company is associated with the job posting on the 10th row? 
      ANSWER: "ExxonMobil". */

SELECT * 
FROM data_analyst_jobs
LIMIT 10;


/* How many postings are in Tennessee? How many are there in either Tennessee or Kentucky?
      ANSWER: 21 in TN; 27 in either TN or KY. */

SELECT COUNT(*)
FROM data_analyst_jobs
WHERE location = 'TN';

SELECT COUNT(*)
FROM data_analyst_jobs
WHERE location IN ('TN', 'KY');


/* How many postings in Tennessee have a star rating above 4?
      ANSWER: 3. */

SELECT COUNT(*)
FROM data_analyst_jobs
WHERE location = 'TN' 
      AND star_rating > 4;


/* How many postings in the dataset have a review count between 500 and 1000?
      ANSWER: 151. */

SELECT COUNT(*)
FROM data_analyst_jobs
WHERE review_count BETWEEN 500 AND 1000;


/* Show the average star rating for companies in each state. The output should show the state as `state` 
   and the average rating for the state as `avg_rating`. Which state shows the highest average rating?
      ANSWER: "Nebraska" with 4.20. */

SELECT location AS state,
       ROUND(avg(star_rating), 2) AS avg_rating
FROM data_analyst_jobs
GROUP BY state
ORDER BY avg_rating DESC NULLS LAST;


/* Select unique job titles from the data_analyst_jobs table. How many are there?
      ANSWER: 881. */

SELECT COUNT(DISTINCT title)
FROM data_analyst_jobs;


/* How many unique job titles are there for California companies?
      ANSWER: 230. */

SELECT COUNT(DISTINCT title)
FROM data_analyst_jobs
WHERE location = 'CA';


/* Find the name of each company and its average star rating for all companies that have more than 5000 reviews 
   across all locations.
   a. How many companies are there with more than 5000 reviews across all locations?
   b. Which company with more than 5000 reviews across all locations in the dataset has the highest star rating? 
   c. What is that rating?
      ANSWER: a. 70 total companies; b. Google; c. 4.3 */

SELECT company, 
       ROUND(AVG(star_rating), 2) AS avg_rating
FROM data_analyst_jobs
WHERE company IS NOT NULL
GROUP BY company
HAVING SUM(review_count) > 5000
ORDER BY avg_rating DESC;


/* Find all the job titles that contain the word ‘Analyst’. How many different job titles are there? 
      ANSWER: 774. */

SELECT DISTINCT title
FROM data_analyst_jobs
WHERE title ILIKE '%Analyst%';


/* How many different job titles do not contain either the word ‘Analyst’ or the word ‘Analytics’? 
   What word do these positions have in common?
      ANSWER: "Tableau". */

SELECT DISTINCT title 
FROM data_analyst_jobs
WHERE title NOT ILIKE '%Analyst%' 
      AND title NOT ILIKE '%Analytics%';


/* Determine which jobs requiring SQL are hard to fill. Find the number of jobs by industry (domain)
   that require SQL and have been posted longer than 3 weeks. Disregard any postings where the domain is NULL.
   a. Which industries are in the top 4 on this list?
   b. How many jobs have been listed for more than 3 weeks for each of the top 4?
      ANSWER: "Internet and Software" with 62 jobs; "Banks and Financial Services" with 61 jobs;
              "Consulting and Business Services" with 57 jobs; and "Health Care" with 52 jobs. */

SELECT domain AS industry,
       COUNT(title) AS jobs_count
FROM data_analyst_jobs
WHERE days_since_posting > 21 
      AND domain IS NOT NULL
      AND skill ILIKE '%SQL%'
GROUP BY industry
ORDER BY jobs_count DESC
LIMIT 4;
