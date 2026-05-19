#!/bin/bash

RG="rg-orderx-lab"
LOC="eastus"
AKS="aks-orderx"
COSMOS="cosmosorderx"
APIM="apimorderx"

az group create -n $RG -l $LOC

az aks create -g $RG -n $AKS --node-count 1 --generate-ssh-keys

az cosmosdb create -g $RG -n $COSMOS --kind MongoDB

az cosmosdb mongodb database create \
  -g $RG -n $COSMOS -d orderx

az apim create \
  -g $RG \
  -n $APIM \
  --publisher-email "test@orderx.com" \
  --publisher-name "orderx" \
  --sku-name Consumption