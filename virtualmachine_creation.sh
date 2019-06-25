#create virtual machines and required architecture
#create architecture

#!/bin/sh
source ~/.bashrc

#create resource group
az group create --name AzureProject --location uksouth
az group list

#setting as default group
az configure --defaults group=AzureProject

#creating virtual network with specified subnet mask
az network vnet create --resource-group AzureProject --name MyVirtualNetwork --address-prefixes 10.0.0.0/16 --subnet-name MySubnet --subnet-prefix 10.0.0.0/24

#create network security group (nsg)
az network nsg create --resource-group AzureProject --name MyNetworkSecurityGroup

#create nsg rule to allow for ssh port
az network nsg rule create --name SSH --destination-port-ranges 22 --nsg-name MyNetworkSecurityGroup --priority 400

#create public IP
az network public-ip create --resource-group AzureProject --name AzureProjectIP --dns-name AzureProject123456789

#create network interface with security group and IP address
az network nic create --resource-group AzureProject --name AzureProjectNetworkInterface --vnet-name MyVirtualNetwork --subnet MySubnet --network-security-group MyNetworkSecurityGroup --public-ip-address AzureProjectIP

#create virtual machines
define virtual machine usernames in a variable to save coding space
vmusers="jenkins jenkinsbuild python"

#writing virtual machine creation into for loop
for vm in ${vmusers}; do
	az vm create --resource-group AzureProject --name $vm --image UbuntuLTS --admin-username "nstephenson" --size Standard_F1
done
