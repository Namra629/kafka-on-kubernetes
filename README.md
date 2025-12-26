# confluent-kafka-on-kubernetes ( installing through helm )

# Pre-requisite 

kubernetes cluster installed

For this, check my github repo 

https://github.com/Namra629/Kubernetes-Cluster-Setup

# Installation Steps

1. Run helm.sh first. Then after running confluent.sh, pods will be in the pending state

<img width="725" height="110" alt="image" src="https://github.com/user-attachments/assets/cad0c452-f3e3-4c03-a7c7-ecfe600cc6bf" />

2. Troubleshoot the erorr

        kubectl describe pod pod-name -n confluent

<img width="1400" height="700" alt="image" src="https://github.com/user-attachments/assets/d25118ab-e837-48eb-92be-c19edc1217d4" />

3.  For PVC t obound to a PV, storage class is necessary.

<img width="530" height="40" alt="image" src="https://github.com/user-attachments/assets/5e46b950-5c0a-4768-bfe4-c9c65451d97a" />
  
4.Run the CSI driver openebs scripts to install the CSI driver and deploy the custom storage class required for the PVC to bound to PV as the kubeadm kubernetes has no default dynamic (automatic) volume provsiioning.

<img width="870" height="250" alt="image" src="https://github.com/user-attachments/assets/9b417bc9-bfbc-41cf-a5bb-1737d6b51e95" /> &nbsp;&nbsp;&nbsp;


<img width="1000" height="100" alt="image" src="https://github.com/user-attachments/assets/62697f94-cd7b-4bd3-8049-a77e44f2e7e8" />


5.  Make a directory on the worker node and set its permissions.

          sudo mkdir -p /var/local-hostpath
          sudo chmod -R 777 /var/local-hostpath
6.  A new sc will be made which will be used as default by kubernetes for all the pods in confluent namespace.

7. Now , all the kafka pods will be in the running state.

   <img width="800" height="300" alt="image" src="https://github.com/user-attachments/assets/6563dfdd-0eb4-4092-ac28-e062e79477f0" />


8. On master node,  Create a service file of control-center to expose it on external port. ( File present in the repository )

9. Apply it

         kubectl apply -f control-center-service.yaml

References:

       https://github.com/confluentinc/confluent-kubernetes-examples/tree/master/quickstart-deploy
       https://openebs.io/docs/3.10.x/user-guides/installation
       https://openebs.io/docs/main/user-guides/local-storage-user-guide/local-pv-hostpath/configuration/hostpath-create-storageclass






      

   
