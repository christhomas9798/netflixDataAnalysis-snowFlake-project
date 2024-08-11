use database netflix_analysis;

----------------------

create or replace table netflix_raw1 (show_id varchar(10) primary key,
	type varchar(10) NULL,
	title nvarchar(200) NULL,
	director varchar(250) NULL,
	cast varchar(1000) NULL,
	country varchar(150) NULL,
	date_added varchar(20) NULL,
	release_year int NULL,
	rating varchar(10) NULL,
	duration varchar(10) NULL,
	listed_in varchar(100) NULL,
	description varchar(500) NULL,
    rnk int )



    insert into netflix_raw1 
WITH a AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY UPPER(title), type ORDER BY show_id) AS rnk
    FROM netflix_raw
)
SELECT *
FROM a
WHERE rnk = 1;

alter table netflix_raw1 drop column rnk --felt this might be a better method to get all the columns except rnk
select * from netflix_raw1


