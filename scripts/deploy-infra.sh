#!/bin/bash

RG="rg-bankx-lab"
LOC="eastus"
AKS="aks-bankx"
COSMOS="cosmosbankx"
APIM="apimbankx"

az group create -n $RG -l $LOC

az aks create -g $RG -n $AKS --node-count 1 --generate-ssh-keys

az cosmosdb create -g $RG -n $COSMOS --kind MongoDB

az cosmosdb mongodb database create \
  -g $RG -n $COSMOS -d bankx

az apim create \
  -g $RG \
  -n $APIM \
  --publisher-email "test@bankx.com" \
  --publisher-name "bankx" \
  --sku-name Consumption