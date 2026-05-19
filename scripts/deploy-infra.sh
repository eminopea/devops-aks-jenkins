#!/bin/bash

RG="rg-orderx-lab"
LOC="westus"
AKS="aks-orderx"
COSMOS="cosmosorderx"
APIM="apimorderx"

echo "🔧 Registering Azure providers..."

az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.DocumentDB
az provider register --namespace Microsoft.ApiManagement

echo "🚀 Creating Resource Group"
az group create -n $RG -l $LOC

echo "🚀 Creating AKS"
az aks create -g $RG -n $AKS --node-count 1 --node-vm-size Standard_B2s --generate-ssh-keys

echo "🚀 Creating CosmosDB"

az cosmosdb create \
  -g $RG \
  -n $COSMOS \
  --kind MongoDB \
  --locations regionName=$LOC

# ✅ verificar creación
if [ $? -ne 0 ]; then
  echo "❌ Cosmos DB creation failed, skipping DB creation"
else
  echo "✅ Creating database"
  az cosmosdb mongodb database create \
    -g $RG \
    -n $COSMOS \
    -d orderx
fi

echo "🚀 Creating APIM"

EXISTS=$(az apim show -g $RG -n $APIM --query "name" -o tsv 2>/dev/null)

if [ "$EXISTS" = "$APIM" ]; then
  echo "✅ APIM already exists, skipping..."
else
  az apim create \
    -g $RG \
    -n $APIM \
    --publisher-email "test@orderx.com" \
    --publisher-name "orderx" \
    --sku-name Consumption
fi