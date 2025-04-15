#!/bin/bash

echo "post-create start" >> ~/.status.log

# Install the K3D cluster
k3d cluster create --config .devcontainer/manifests/k3d-dev.yaml --wait | tee -a ~/.status.log

# Install Argo CD using Helm
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm install argocd argo/argo-cd --namespace argocd --create-namespace \
    --set server.service.type="NodePort" \
    --set server.service.nodePortHttp=30272


echo "post-create complete" >> ~/.status.log
