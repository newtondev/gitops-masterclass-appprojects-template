#!/bin/bash

echo "post-start start" >> ~/status.log

# this runs in background each time the container starts

# Ensure kubeconfig is set up. 
k3d kubeconfig merge dev --kubeconfig-merge-default

# Install Argo CD using Helm
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm install argocd argo/argo-cd --namespace argocd --create-namespace --values ../manifests/argocd-values.yaml

bash .devcontainer/scripts/update-repo-for-workshop.sh

# Best effort env load
source ~/.bashrc

echo "post-start complete" >> ~/status.log
