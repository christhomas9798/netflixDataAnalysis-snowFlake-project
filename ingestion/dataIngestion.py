import os
import kaggle
import subprocess
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient
from azure.storage.blob import BlobServiceClient, BlobClient

# Initialize Key Vault client
key_vault_name = "snowflake-netflix-kv"
key_vault_uri = f"https://snowflake-netflix-kv.vault.azure.net/"
credential = DefaultAzureCredential()
secret_client = SecretClient(vault_url=key_vault_uri, credential=credential)

# Retrieve secrets
adls_access_key = secret_client.get_secret("adlsAccessKey").value
#kaggle_api_key = secret_client.get_secret('kaggleApiKey').value
##os.environ['KAGGLE_JSON'] = kaggle_api_key

kaggle_dataset_url = 'shivamb/netflix-shows' 
#local_csv_path = '/Users/christopher.thomas/Documents/python_virtual/netflix_titles.csv'

adls_account_name = 'snow9798'
adls_container_name = 'raw'
adls_blob_path = 'netflix_titles.csv'

subprocess.run(f'kaggle datasets download -d {kaggle_dataset_url} -f netflix_titles.csv', shell=True, check=True)

import zipfile
zip_ref = zipfile.ZipFile('netflix_titles.csv.zip') 
zip_ref.extractall() # extract file to dir
zip_ref.close() # close file

connection_string = f"DefaultEndpointsProtocol=https;AccountName={adls_account_name};AccountKey={adls_access_key};EndpointSuffix=core.windows.net"
blob_service_client = BlobServiceClient.from_connection_string(connection_string)

# Upload CSV to ADLS Gen2
container_client = blob_service_client.get_container_client(adls_container_name)
blob_client = container_client.get_blob_client(adls_blob_path)

with open(local_csv_path, 'rb') as data:
    blob_client.upload_blob(data, overwrite=True)

print(f"Dataset uploaded to ADLS Gen2 at {adls_container_name}/{adls_blob_path}")
