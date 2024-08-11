----------------------
use database netflix_analysis;

create or replace file format snow_csv_format
type='csv'
field_delimiter=','
skip_header=1

alter file format snow_csv_format set field_optionally_enclosed_by='"'

describe file format snow_csv_format 

----------------------

create or replace stage snow_netflix_stage 
storage_integration=snow_integration
file_format=snow_csv_format
url='azure://snow9798.blob.core.windows.net/raw';

list @snow_netflix_stage;



select $1 from @snow_netflix_stage;


