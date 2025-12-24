#!/bin/bash

set -e


kubectl apply -f https://openebs.github.io/charts/openebs-operator.yaml
kubectl get sc
kubectl get pods -n openebs --watch

# Creating a custom storage class with our own custom path set on worker node

cat << EOF > openebsstorageclass.yaml

apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: openebs-hostpath-custom
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: openebs.io/local
volumeBindingMode: WaitForFirstConsumer
reclaimPolicy: Delete
parameters:
  basePath: /var/local-hostpath

EOF


