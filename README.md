# kafka-on-kubernetes

1. After running the scripts, pods will be in the pending state

<img width="700" height="100" alt="image" src="https://github.com/user-attachments/assets/cad0c452-f3e3-4c03-a7c7-ecfe600cc6bf" />

2. Troubleshoot the erorr

        kubectl describe pod pod-name -n confluent

<img width="1400" height="700" alt="image" src="https://github.com/user-attachments/assets/d25118ab-e837-48eb-92be-c19edc1217d4" />

3.  For PVC t obound to a PV, storage class is necessary.

<img width="537" height="46" alt="image" src="https://github.com/user-attachments/assets/5e46b950-5c0a-4768-bfe4-c9c65451d97a" />
  
4.Run the CSI driver openebs scripts to install the CSI driver and deploy the custom storage class required for the PVC to bound to PV as the kubeadm kubernetes has no default dynamic (automatic) volume provsiioning.

5. 

   
