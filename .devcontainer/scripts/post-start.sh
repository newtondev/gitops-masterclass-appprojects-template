#!/bin/bash

echo "post-start start" >> ~/status.log

# this runs in background each time the container starts

# Ensure kubeconfig is set up. 
k3d kubeconfig merge dev --kubeconfig-merge-default

# Update the repo for the workshop
bash .devcontainer/scripts/update-repo-for-workshop.sh

# Update Argo CD Admin Password
argopass=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' | base64 -d)
argouri="localhost:30272"
argonewpass="password"
argocd login --insecure --username ${argouser:=admin} --password ${argopass} --grpc-web ${argouri}
argocd account --insecure update-password --insecure --current-password ${argopass} --new-password ${argonewpass}

# Best effort env load
source ~/.bashrc

echo "post-start complete" >> ~/status.log
