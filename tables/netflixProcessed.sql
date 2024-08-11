use database netflix_analysis;

----------------------

select * from netflix_raw1 where duration is null;

SELECT  DATE('August 4, 2017', 'MMMM DD, YYYY') AS formatted_date;


create or replace table netflix_processed as 
select show_id,type,title, case when date_added is not null then
to_DATE(trim(date_added), 'MMMM DD, YYYY') 
else case when release_year>=2009 then to_date('December '||'31, '||release_year,'MMMM DD, YYYY')
else 
to_date('December '||'31, '||'2008','MMMM DD, YYYY')
end end
as date_added , release_year,rating, case when duration is null then rating else duration end as duration from netflix_raw1 ;

select * from netflix_raw1 where date_added is null;


