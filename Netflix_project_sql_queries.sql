create database netflix;
use netflix;
select * from netflix_uncleaned_8000_rows;
alter table netflix_uncleaned_8000_rows 
rename  to Netflix;

select * from netflix;

select count(*) from netflix;

select distinct type from netflix;

select title , count(title) from netflix
group by title
having  count(title) > 1;

select * from netflix
where title = 'Secret Files 367';

select release_year from netflix
where release_year like '%.%';

update netflix
set type = upper(type);

update netflix
set type = 'TV Show'
where type = 'TV SHOW';

update netflix
set type = 'Movie'
where type = 'MOVIE';

update netflix
set country = NULL
where country = ' ';

update netflix
set cast = NULL
where cast = '';

update netflix
set director = null
where director = '';

update netflix
set duration = null
where duration = '';

update netflix 
set rating = 'NR'
where rating = '';

update netflix 
set release_year = null
where release_year = 0;

update netflix
set description = 'No description'
where description = '';

update netflix
set listed_in = trim(listed_in),
	title = trim(title),
    cast = trim(cast),
    country = trim(country);

update netflix
set release_year = floor(release_year);

alter table netflix
modify release_year int;

alter table netflix 
add column S_No int auto_increment primary key first;
    
UPDATE netflix
SET date_added = CASE 
    WHEN date_added LIKE '__-__-____' THEN STR_TO_DATE(date_added, '%d-%m-%Y')
    WHEN date_added LIKE '____-__-__' THEN STR_TO_DATE(date_added, '%Y-%m-%d')
    WHEN date_added LIKE '%/%/%' THEN STR_TO_DATE(date_added, '%m/%d/%Y')
    WHEN date_added LIKE '%, %' THEN STR_TO_DATE(date_added, '%M %e, %Y')
    ELSE NULL END;

update netflix
set director = replace(director,'Dir.','Director');

alter table netflix
add duration_min int;

alter table netflix
add seasons varchar(20);

update netflix
set duration_min = case when duration like '%min%' then cast(substring_index(duration,' ',1) as unsigned) end;

update netflix
set seasons = case when duration like '%seasons%' then cast(substring_index(duration,' ',1) as unsigned) end;

alter table netflix
drop column duration;

select * from netflix;

-- Total no. of movies directed and highest no. of movies/shows directed by each Director.
select director , count(title) as total_no_of_Movies from netflix where type='Movie'and director is not null
group by director  order by total_no_of_Movies desc;

select director , count(title) as total_no_of_TVShows from netflix where type='TV Show'and director is not null
group by director  order by total_no_of_TVShows desc;

-- Total no. of movies directed and highest no. of movies/shows directed by each Director in United States
select director , count(title) as total_no_of_Movies_in_USA from netflix
where country = 'United States'
group by director order by total_no_of_Movies_in_USA desc;


-- Total no. of films by type
select type , count(*) as total_count from netflix
group by type;

-- Total no. of films (per country) and which country has highest no. of movies/tv shows;
select country as CountryName , count(title) as Total_Count from netflix
group by country having countryname is not null order by Total_Count desc ;

-- No. of Movies/TV Shows in each Genre and which Genre has highest no. of Shows.
select listed_in , count(title) as Total_Count from netflix
group by listed_in order by Total_Count DESC; 

-- Total no. of Movies/TV Shows Released after 2000s.
select count(*) as Total_Movies_TVShows_Count_after_2000s from netflix
where release_year >= 2000;

-- Total no. of Movies/TV Shows Released before 2000s.
select count(*) as Total_Movies_TVShows_Count_before_2000s from netflix
where release_year < 2000;

-- TOP 10 Longest Movie
select title , concat(duration_min,' ','min') from netflix
where type = 'movie'
order by duration_min desc limit 10;

-- TOP 10 Longest TV Show
select title , concat(seasons,' ','seasons') from netflix
where type = 'TV Show'
order by seasons desc limit 10;

-- Total no. of Movies/TV shows by each rating(category) and most Movies/TV shows in each rating category.
select rating as Rating_Category , count(title) as total_count from netflix where rating <>'NR'
group by rating order by total_count desc;

-- TV shows with 2nd Highest Seasons
select * from(select title ,seasons , type ,
dense_rank() over (order by seasons desc)  as rnk from netflix where type= 'Tv Show') sub
where rnk = 2 limit 1;

-- TV shows with Highest Seasons in each genre and their rating.
select * from(select title ,seasons,listed_in,rating,
row_number() over (partition by listed_in order by seasons desc)  as rnk from netflix
 where type = 'TV show') sub
where rnk = 1;

-- Top 3 TV Shows from each Genre.
-- with cte
with TvShow as ( select title,type , listed_in ,seasons from netflix where type = 'TV Show'),
TvShow2 as
(select title, listed_in , type , row_number() over(partition by listed_in order by seasons) as rnk from TvShow)
select * from TvShow2
having rnk <=3;

-- Sub and Windows
select * from
(select title,listed_in,type,row_number()over(partition by listed_in order by seasons) as rnk from netflix 
where type = 'TV Show') sub
where rnk <= 3 ;

-- Aerage Movies Durartion by each country and highest Average movie duration.
select country , avg(duration_min) as avg_duration from netflix
group by country order by avg_duration desc;

-- Aerage TV Show Durartion by each country and highest Average TV Show duration.
select country , round(avg(seasons),2) as avg_seasons from netflix
group by country order by avg_seasons desc;

-- Last 5 year release Trend (Movies/TVShow).
select Release_year , count(*) as total_content_count from netflix
where release_year >= year(current_date())-11
group by release_year
order by release_year;

select * from netflix;

-- total count of listed in by each country.
-- 1. (with rankings / cte) --
with GenreCounts as
(select country,listed_in,count(*) as totalcount from netflix
where country is not null
group by country,listed_in)
select * , 
row_number() over(partition by country order by totalcount desc) as rnk
 from Genrecounts;
 
-- 2. (without rankings) --
 select country,listed_in,count(*) as totalcount from netflix
where country is not null
group by country,listed_in order by country,totalcount desc;

-- 3. (with rankings / windows Function) --
select country , listed_in , count(*) ,
 row_number() over(partition by country order by count(*) desc) as rnk from netflix
 where country is not null
group by country , listed_in;

-- Running (Movies/TV Shows) Totalcount over years.
select release_year , count(*) as totalcount from netflix
group by release_year order by release_year;

-- avg movie duration
select avg(duration_min) from netflix;

-- Viewer preference leans towards which duration movies
SELECT 
  CASE 
    WHEN duration_min < 90 THEN 'Short'
    WHEN duration_min BETWEEN 90 AND 120 THEN 'Mid-duration'
    WHEN duration_min > 120 THEN 'Long'
  END AS duration_category,
  COUNT(*) AS total_movies
FROM netflix
WHERE type = 'Movie' and duration_min is not null
GROUP BY duration_category
ORDER BY total_movies DESC;

select * from netflix;

