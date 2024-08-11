use database netflix_analysis;

----------------------

create or replace table netflix_raw (show_id varchar(10) primary key,
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
	description varchar(500) NULL);


copy into netflix_raw from @snow_netflix_stage
file_format = snow_csv_format;

----------------------


select lower(title)--,count(*) 
from netflix_raw group by lower(title) having count(*)>1 order by lower(title);





