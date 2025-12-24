#!/bin/bash

set -e


kubectl apply -f https://openebs.github.io/charts/openebs-operator.yaml
kubectl get sc
kubectl get pods -n openebs --watch

