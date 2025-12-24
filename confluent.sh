#!/bin/bash

# Deploy Confluent for Kubernetes using Helm


# Exit immediately if a command exits with a non-zero status
set -e



# Create Kubernetes namespace for Confluent
echo "Creating Kubernetes namespace 'confluent'..."
kubectl create namespace confluent 

 # Set the namespace as default for the current context
kubectl config set-context --current --namespace=confluent
echo "Namespace 'confluent' set as default for current context"

# Add Confluent Helm repository
echo "Adding Confluent Helm repository..."
helm repo add confluentinc https://packages.confluent.io/helm
helm repo update

# Install/upgrade Confluent for Kubernetes using Helm
echo "Installing/upgrading Confluent Operator..."
helm upgrade --install confluent-operator confluentinc/confluent-for-kubernetes --namespace confluent

# Check that the Confluent Operator pods are running
echo "Checking pods in namespace 'confluent'..."
kubectl get pods

# Deploy Confluent Platform custom resources

cat <<EOF > confluent-platform.yaml
apiVersion: platform.confluent.io/v1beta1
kind: Kafka
metadata:
  name: kafka
  namespace: confluent
spec:
  replicas: 3
  image:
    application: confluentinc/cp-server:7.9.0
    init: confluentinc/confluent-init-container:2.11.0
  dataVolumeCapacity: 10Gi
  metricReporter:
    enabled: true
  dependencies:
    zookeeper:
      endpoint: zookeeper.confluent.svc.cluster.local:2181
EOF

# Apply this yaml 

kubectl apply -f confluent-platform.yaml

# See the Confluent Platform Resources Deployed or not

kubectl get confluent


echo "Confluent for Kubernetes deployment script completed successfully!"

