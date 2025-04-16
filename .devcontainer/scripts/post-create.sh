#!/bin/bash

echo "post-create start" >> ~/.status.log

# Install the K3D cluster
k3d cluster create --config .devcontainer/manifests/k3d-dev.yaml --wait | tee -a ~/.status.log

# Install Argo CD using Helm
helm repo add argo https://argoproj.github.io/argo-helm | tee -a  ~/.status.log 
helm repo update | tee -a  ~/.status.log 
helm install argocd argo/argo-cd --version 7.8.26 --namespace argocd --create-namespace --set server.service.type="NodePort"  --set server.service.nodePortHttps=30272 | tee -a  ~/.status.log 

echo "post-create complete" >> ~/.status.log
