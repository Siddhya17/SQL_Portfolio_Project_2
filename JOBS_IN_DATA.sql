CREATE TABLE Jobs
(
work_year int,
job_title varchar,
job_category varchar,
salary_currency varchar,
salary int,
salary_in_usd int,
employee_residence varchar,
experience_level varchar,
employment_type varchar,
work_setting varchar,
company_location varchar,
company_size varchar
);

COPY Jobs (work_year, job_title, job_category, salary_currency, salary, salary_in_usd, employee_residence, experience_level, employment_type, work_setting, company_location, company_size)
FROM 'C:\Users\Siddhesh\Desktop\SQL\Reference\jobs_in_data.csv\jobs.csv'
DELIMITER ','
CSV HEADER;

--1-Retrieve all columns for employees with the job title 'Data Analyst'.

SELECT *
FROM Jobs
WHERE job_title = 'Data Analyst';

--2-List distinct job categories present in the dataset.

SELECT DISTINCT(job_category)
FROM Jobs;

--3-Find the average salary (in USD) for all job categories.

SELECT job_category, ROUND(AVG(salary_in_usd), 2) AS Avg_salary_in_USD
FROM Jobs
GROUP BY job_category
ORDER BY job_category;

--4-Identify the top 5 job titles with the highest average salary.

SELECT job_title, ROUND(AVG(salary), 2) AS Avg_Salary
FROM Jobs
GROUP BY job_title
ORDER BY Avg_Salary DESC
LIMIT 5;

--5-Calculate the total number of employees for each experience level.

SELECT COUNT(job_title) AS No_of_Employees, experience_level
FROM Jobs
GROUP BY experience_level
ORDER BY experience_level DESC;

--6-Retrieve the job title and salary for employees with a salary greater than $100,000 USD.

SELECT job_title, salary_in_usd
FROM Jobs
WHERE salary_in_usd > 100000
ORDER BY job_title;

--7-Determine the average salary for each company size.

SELECT company_size, ROUND(AVG(salary), 2) AS Avg_Salary
FROM Jobs
GROUP BY company_size
ORDER BY company_size DESC;

--8-Find the company location with the highest average salary for Data Scientists.

SELECT company_location, job_title, ROUND(AVG(Salary), 2) AS Avg_Salary
FROM Jobs
WHERE job_title = 'Data Scientist'
GROUP BY company_location, job_title
ORDER BY Avg_salary DESC
LIMIT 1;

--9-Identify the top 3 job titles with the highest total salary across all companies.

SELECT job_title, SUM(salary) AS Total_salary
FROM Jobs
GROUP BY job_title
ORDER BY Total_salary DESC
LIMIT 3;

--10-Calculate the median salary for each job category.

SELECT
  job_category,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) AS median_salary
FROM
  Jobs
GROUP BY
  job_category;
  
--11-Retrieve the job title and salary for employees who work in a remote setting and have an experience level of 'Senior'.

SELECT Job_title, salary
FROM Jobs
WHERE work_setting = 'Remote' AND Experience_level = 'Senior';

--12-Find the company size with the highest number of employees.

SELECT company_size, COUNT(job_title) AS No_of_Employees
FROM jobs
GROUP BY company_size
ORDER BY No_of_Employees DESC
LIMIT 1;

--13-Calculate the average salary for each job title in the 'Technology' job category.

SELECT job_title, ROUND(AVG(Salary), 2) AS Avg_Salary
FROM Jobs
WHERE job_category = 'Technology'
GROUP BY job_title
ORDER BY Job_title;

--14-Identify the top 3 companies with the highest total salary payout.

SELECT company_location, SUM(SALARY) AS Total_Salary
FROM Jobs
GROUP BY company_location
ORDER BY Total_salary DESC
limit 3;

--15-Find the job title with the highest salary for employees working in 'Large' companies.

SELECT Job_title, MAX(salary) AS HIGHEST_SALARY
FROM Jobs
WHERE company_size = 'L'
GROUP BY job_title;

--16-Determine the company location with the highest average salary for employees with an experience level of 'Mid-Level'.

SELECT company_location, ROUND(AVG(SALARY), 2) AS Highest_avg_salary
FROM Jobs
WHERE experience_level = 'Mid-level'
GROUP BY company_location
ORDER BY Highest_avg_salary DESC
LIMIT 1;

--17-Identify the job title with the highest salary in each job category.

WITH CTE AS
(
SELECT job_title,
       job_category,
       salary,
       ROW_NUMBER() OVER(PARTITION BY job_category ORDER BY salary DESC) AS Rank
FROM Jobs
)
SELECT job_title, job_category, salary
FROM CTE
WHERE Rank = 1;

--18-Calculate the average salary for employees in each company size, considering only those with an 'Advanced' experience level.

SELECT company_size, ROUND(AVG(SALARY), 2) AS Avg_salary
FROM Jobs
WHERE Experience_level = 'Advanced'
GROUP BY company_size;

--19-Find the job title with the highest salary increase from the year 2022 to 2023.

WITH CTE AS 
(
SELECT
JOB_TITLE,
MAX(CASE WHEN work_year = 2022 THEN SALARY END) AS SALARY_2022,
MAX(CASE WHEN work_year = 2023 THEN SALARY END) AS SALARY_2023
FROM Jobs
WHERE work_year IN (2022, 2023)
GROUP BY JOB_TITLE
)
SELECT JOB_TITLE,
SALARY_2022,
SALARY_2023,
(SALARY_2023 - SALARY_2022) AS SALARY_INCREASE
FROM CTE
ORDER BY SALARY_INCREASE DESC
LIMIT 1;

