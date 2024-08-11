create or replace database netflix_analysis;
----------------------
use database netflix_analysis;

create storage integration snow_integration
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = 'AZURE'
ENABLED = TRUE
azure_tenant_id='************************'
STORAGE_ALLOWED_LOCATIONS = ('azure://snow9798.blob.core.windows.net/raw')
COMMENT = 'Integration for Azure Blob Storage';

describe integration snow_integration;