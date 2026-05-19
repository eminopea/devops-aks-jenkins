#!/bin/bash

RG="rg-orderx-lab"
LOCATION="eastus"

echo "🧨 Deleting Resource Group"
az group delete -n $RG --yes --no-wait

echo "🧹 Purging APIM"

for name in $(az apim deletedservice list --query "[].name" -o tsv); do
  if [ ! -z "$name" ]; then
    echo "Purging APIM: $name"
    
    az apim deletedservice purge \
      --service-name $name \
      --location $LOCATION
  fi
done

echo "✅ Cleanup completed"
