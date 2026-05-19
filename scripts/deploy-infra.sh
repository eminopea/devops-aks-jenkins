#!/bin/bash

RG="rg-orderx-lab"
LOC="eastus"
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
az cosmosdb create -g $RG -n $COSMOS --kind MongoDB

az cosmosdb mongodb database create \
  -g $RG -n $COSMOS -d orderx

echo "🚀 Creating APIM"
az apim create \
  -g $RG \
  -n $APIM \
  --publisher-email "test@orderx.com" \
  --publisher-name "orderx" \
  --sku-name Consumption