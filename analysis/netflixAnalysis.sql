use database netflix_analysis;

----------------------
--Q1. Get the list the of directors who have created both movies and series, along with their total movies & series count in separate columns 

select nd.director,sum(case when type='Movie' then 1 else 0 end) as total_movies
, sum(case when type='TV Show' then 1 else 0 end) as total_series from netflix_processed np join netflix_director nd on np.show_id=nd.show_id group by nd.director having 
total_movies<>0 and total_series<>0
order by total_movies + total_series desc;

select * from netflix_raw1 where director is null;

----------------------
--Q2 Top 10 Countries with the highest number of comedy movies

select nc.country,sum( case when lower(ng.genre) like 'comedies' then 1 else 0 end) as total_comedy_movies  from netflix_processed np join netflix_country nc on np.show_id=nc.show_id
join netflix_genre ng on ng.show_id=np.show_id 
where type='Movie'
group by nc.country order by total_comedy_movies desc limit 10;

select * from netflix_processed np join netflix_genre ng on np.show_id =ng.show_id where type='Movie' and lower(ng.genre) like '%comed%' and ng.genre<>'Comedies';

----------------------
--Q3 Director with maximum number of movies for each year

with cte as (
select to_char(date_added ,'yyyy') as year ,nd.director, rank() over (partition by year order by count(*) desc,director) as rnk from netflix_processed np join netflix_director nd on np.show_id=nd.show_id where type='Movie' 
group by year,nd.director )
select year,director from cte where rnk=1 order by year desc;

----------------------
-- Q4 Find the average duration of movies in each genre

select * , substr(trim(duration),1,charindex(' ',trim(duration))-1) from netflix_processed;

select genre, round(avg(substr(trim(duration),1,charindex(' ',trim(duration))-1)),2) as average_duration  from netflix_processed np join netflix_genre ng on ng.show_id=np.show_id where type='Movie'
group by genre order by average_duration desc;


----------------------
-- Q5 Get the list the of directors who have created both comedy and horror movies, along with their total comedy and horror movie count in separate columns 

select director, sum(case when genre ='Horror Movies' then 1 else 0 end) as horror_count,
sum(case when lower(genre) ='comedies' then 1 else 0 end) as comedy_count
from netflix_processed np join netflix_director nd on np.show_id=nd.show_id join
netflix_genre ng on ng.show_id=np.show_id where np.type='Movie'
group by director 
having horror_count<>0 and comedy_count<>0 
order by horror_count+comedy_count desc;

select distinct genre from netflix_genre where lower(genre) like '%horr%';