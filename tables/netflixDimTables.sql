
use database netflix_analysis;

----------------------
create or replace  table netflix_director as
select show_id,trim(value) as director  from netflix_raw1, lateral flatten(split(director,','));

select * from netflix_director;

----------------------

create or replace  table netflix_genre as
select show_id,trim(value) as genre  from netflix_raw1, lateral flatten(split(listed_in,','));

select * from netflix_genre;

----------------------

create or replace  table netflix_country as
select show_id,trim(value) as country  from netflix_raw1, lateral flatten(split(country,','));

select * from netflix_country;

----------------------

create or replace  table netflix_cast as
select show_id,trim(value) as cast  from netflix_raw1, lateral flatten(split("CAST",','));

select * from netflix_cast;
----------------------


insert into netflix_country 
select show_id,m.country from netflix_raw1 nr join (
select director,country from netflix_director d join netflix_country c on d.show_id=c.show_id
group by director,country ) m on nr.director=m.director where nr.country is null;


select * from netflix_country order by show_id where country is null

