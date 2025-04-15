#!/bin/bash

echo "post-start start" >>  ~/.status.log 

# this runs in background each time the container starts

# Ensure kubeconfig is set up. 
k3d kubeconfig merge dev --kubeconfig-merge-default | tee -a ~/.status.log 

# Update the repo for the workshop
bash .devcontainer/scripts/update-repo-for-workshop.sh | tee -a  ~/.status.log 

# Wit for Argo CD to be ready
kubectl rollout status -n argocd sts/argocd-application-controller | tee -a  ~/.status.log

# Update Argo CD Admin Password
argopass=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' | base64 -d)
argouri="localhost:30272"
argonewpass="password"
argocd login --insecure --username ${argouser:=admin} --password ${argopass} --grpc-web ${argouri} | tee -a  ~/.status.log 
argocd account --insecure update-password --insecure --current-password ${argopass} --new-password ${argonewpass} | tee -a  ~/.status.log 

# Best effort env load
source ~/.bashrc

echo "post-start complete" >>  ~/.status.log 
