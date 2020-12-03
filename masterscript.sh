#script to fully automate the creation of a jenkins server, jenkins build slave and a static python server in Microsoft Azure
#done by first creating three virtual machines in an ubuntu server image
#
#!/bin/sh
#create virtual machines and corresponding architecture
#define names for three virtual machines to be created (to be used in for loop for effciency)
vmusers="jenkins jenkinsbuild python"

#create resource group on azure to contain all resources required
az group create --name AzureProject --location uksouth

#create virtual network to host all virtual machines/resources on
az network vnet create --resource-group AzureProject --name AzureProject-VirtualNetwork --address-prefixes 10.0.0.0/16 --subnet-name MySubnet --subnet-prefix 10.0.0.0/24

#for each of the virtual machine names defined, create a corresponding vm with a unique nsg that allows ssh ports
#each VM should have its own unique public and private IP address and NIC
for vm in ${vmusers}; do
        #create network security group (nsg) for each machine
        az network nsg create --resource-group AzureProject --name $vm-NSG
        
        #create nsg rule to allow for ssh port forwarding
        az network nsg rule create -- resource-group AzureProject --name SSH --destinaton-port-ranges 22 --nsg-name $vm0NSG --priority 400
        
        #create public IP for each VM
        az network public-ip create --resource-group AzureProject --name $vm-IP --dns-name $vm-123456789
        
        #create network interface card (NIC)
        az network nic create --resource-group AzureProject --name $vm-nic --vnet-name AzureProject-VirtualNetwork --subnet MySubnet --network-security-group $vm-NSG --public-ip-address $vm-IP
        
        #create the virtual machine
        az vm create --resource-group AzureProject --name $vm --image UbuntuLTS --nics $vm-nic --admin-username "nstephenson" --size Standard_F1 --generate-ssh-keys
 done
