#!/bin/bash

RG="rg-bankx-lab"
AKS="aks-bankx"
APIM="apimbankx"

echo "🔑 Connect AKS"
az aks get-credentials -g $RG -n $AKS --overwrite-existing

echo "🌐 Install Ingress"
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install nginx ingress-nginx/ingress-nginx \
  --set controller.service.type=LoadBalancer

echo "⏳ Waiting for IP..."
sleep 120

INGRESS_IP=$(kubectl get svc nginx-ingress-nginx-controller \
  -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "✅ IP: $INGRESS_IP"

echo "🔗 Creating APIM Backend"
az apim backend create \
  --resource-group $RG \
  --service-name $APIM \
  --backend-id aks-backend \
  --protocol http \
  --url http://$INGRESS_IP