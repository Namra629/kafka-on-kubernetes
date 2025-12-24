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

---
apiVersion: platform.confluent.io/v1beta1
kind: Zookeeper
metadata:
  name: zookeeper
  namespace: confluent
spec:
  replicas: 3
  image:
    application: confluentinc/cp-zookeeper:7.9.0
    init: confluentinc/confluent-init-container:3.1.0
  dataVolumeCapacity: 10Gi
  logVolumeCapacity: 10Gi
---
apiVersion: platform.confluent.io/v1beta1
kind: Kafka
metadata:
  name: kafka
  namespace: confluent
spec:
  replicas: 3
  image:
    application: confluentinc/cp-server:7.9.0
    init: confluentinc/confluent-init-container:3.1.0
  dataVolumeCapacity: 100Gi
  metricReporter:
    enabled: true
  dependencies:
    zookeeper:
      endpoint: zookeeper.confluent.svc.cluster.local:2181
---
apiVersion: platform.confluent.io/v1beta1
kind: Connect
metadata:
  name: connect
  namespace: confluent
spec:
  replicas: 1
  image:
    application: confluentinc/cp-server-connect:7.9.0
    init: confluentinc/confluent-init-container:3.1.0
  dependencies:
    kafka:
      bootstrapEndpoint: kafka:9071
---
apiVersion: platform.confluent.io/v1beta1
kind: KsqlDB
metadata:
  name: ksqldb
  namespace: confluent
spec:
  replicas: 1
  image:
    application: confluentinc/cp-ksqldb-server:7.9.0
    init: confluentinc/confluent-init-container:3.1.0
  dataVolumeCapacity: 10Gi
---
apiVersion: platform.confluent.io/v1beta1
kind: ControlCenter
metadata:
  name: controlcenter
  namespace: confluent
spec:
  replicas: 1
  image:
    application: confluentinc/cp-enterprise-control-center:7.9.0
    init: confluentinc/confluent-init-container:3.1.0
  dataVolumeCapacity: 10Gi
  dependencies:
    schemaRegistry:
      url: http://schemaregistry.confluent.svc.cluster.local:8081
    ksqldb:
    - name: ksqldb
      url: http://ksqldb.confluent.svc.cluster.local:8088
    connect:
    - name: connect
      url: http://connect.confluent.svc.cluster.local:8083
---
apiVersion: platform.confluent.io/v1beta1
kind: SchemaRegistry
metadata:
  name: schemaregistry
  namespace: confluent
spec:
  replicas: 3
  image:
    application: confluentinc/cp-schema-registry:7.9.0
    init: confluentinc/confluent-init-container:3.1.0
---
apiVersion: platform.confluent.io/v1beta1
kind: KafkaRestProxy
metadata:
  name: kafkarestproxy
  namespace: confluent
spec:
  replicas: 1
  image:
    application: confluentinc/cp-kafka-rest:7.9.0
    init: confluentinc/confluent-init-container:3.1.0
  dependencies:
    schemaRegistry:
      url: http://schemaregistry.confluent.svc.cluster.local:8081
      
EOF

# Apply this yaml 

kubectl apply -f confluent-platform.yaml

# See the Confluent Platform Resources Deployed or not

kubectl get confluent


echo "Confluent for Kubernetes deployment script completed successfully!"

