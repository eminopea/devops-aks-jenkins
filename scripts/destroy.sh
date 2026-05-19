#!/bin/bash

RG="rg-bankx-lab"
LOCATION="eastus"

echo "🧨 Deleting Resource Group"
az group delete -n $RG --yes --no-wait
 
echo "🧹 Purging APIM"
az apim deletedservice list --query "[].name" -o tsv | while read name; do
  az apim deletedservice purge --name $name --location $LOCATION
done