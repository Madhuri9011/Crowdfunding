create database crowdfunding;
use crowdfunding;
-- q1. Date fields to Natural Time
select from_unixtime(created_at) from projects;
select from_unixtime(deadline) from projects;
select from_unixtime(updated_at) from projects;
select from_unixtime(State_changed_at) from projects;
select from_unixtime(successful_at) from projects;
-- q2. Calender table from Created date field
select year(from_unixtime(created_at)) as Year from projects;
select month(from_unixtime(created_at)) as Month from projects;
select monthname(from_unixtime(created_at)) as Year from projects;
select concat("Q", quarter(from_unixtime(created_at))) as Quarter from projects;
SELECT date_format(FROM_UNIXTIME(created_at), '%Y-%m') "year&month" from projects;
select weekday(from_unixtime(created_at)) as weekdayno from projects;
select date_format(FROM_UNIXTIME(created_at), '%W') as weekday_name from projects;
select concat("FM", mod(month(from_unixtime(created_at)) + 9, 12) + 1) as financial_month from projects;
select concat('FQ', quarter(date_add(FROM_UNIXTIME(created_at), INTERVAL -3 MONTH))) AS financial_quarter from projects;

-- q4. goal amount into usd using static usd rate
select concat("$", goal*static_usd_rate) as goal_usd from projects;
-- q5. total number of projects based on outcome
select count(ProjectID) as Projects, State from projects
group by state;
--     total number of projets based on loctions
select count(p.projectID) as Projects, l.country
from projects p inner join location_csv l
on p.location_id=l.id
group by l.country;
--     total number of projects based on category
select count(p.projectID) as Projects, c.name as category
from projects p inner join category c
on p.category_id=c.ï»¿id
group by c.name;
--      total nuber of projects created by year, quarter, month
-- Year
select count(*) as Projects, year(from_unixtime(created_at)) as Year from projects
group by year(from_unixtime(created_at));
-- Quarter
select count(*) as Projects, concat("q", quarter(from_unixtime(created_at))) as Quarter from projects
group by Quarter;
-- month
select count(*) as Projects, monthname(from_unixtime(created_at)) as month from projects
group by month;

-- q6. successful projects 
-- amount raised
select sum(pledged) as Amount_Raised from projects
where state="successful";
-- number of backers
select sum(backers_count) as Backers from projects
where state="successful";
-- avg no. of days for successful projects
select avg((successful_at- created_at) /86400) as avg_days from projects
where state="successful";

-- q7. top succesful projects
-- based on no. Backers 
select name, backers_count from projects
where state="successful"
order by backers_count desc
limit 10;
-- based on amount raised
select name, pledged  from projects
where state ="successful"
order by pledged desc
limit 10;

-- q8. 
-- percentage of successful projects overall
select round((count(case when state="successful" then 1 end)*100.0)/count(*), 2) as percentage from projects;
-- prcentage of successful projects b category
select c.name, count(case when p.state="successful" then 1 end)*100.0/count(*) as percentage
from projects p inner join category c
on p.category_id=c.ï»¿id
group by c.name;
-- percentage of successful projects by year and month
-- year
select year(from_unixtime(created_at)) as year,  round(count((case when state="successful" then 1 end)*100.0)/count(*),2) as percentage
from projects
group by year;
-- month
select monthname(from_unixtime(created_at)) as Month,  round(count((case when state="successful" then 1 end)*100.0)/count(*),2) as percentage
from projects
group by month;
-- percentage of successful projects goal range
select 
    CASE 
        WHEN goal BETWEEN 0 AND 4999 THEN '0-4999'
        WHEN goal BETWEEN 5000 AND 9999 THEN '5000-9999'
        WHEN goal BETWEEN 10000 AND 19999 THEN '10000-19999'
        ELSE '20000+'
    END AS goal_range,
    ROUND(SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2)  as percentage
from projects
group by goal_range;