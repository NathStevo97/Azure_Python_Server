#create virtual machines and required architecture
#create architecture

#!/bin/sh
source ~/.bashrc

#create virtual machines
#define virtual machine usernames in a variable to save coding space
vmusers="jenkins jenkinsbuild python"

#writing virtual machine creation into for loop

#creating virtual network with specified subnet mask
#create resource group
az group create --name AzureProject --location uksouth

az network vnet create --resource-group AzureProject --name AzureProject-VirtualNetwork --address-prefixes 10.0.0.0/16 --subnet-name MySubnet --subnet-prefix 10.0.0.0/24
for vm in ${vmusers}; do
	#create network security group (nsg)
	az network nsg create --resource-group AzureProject --name $vm-NSG

	#create nsg rule to allow for ssh port
	az network nsg rule create --name SSH --destination-port-ranges 22 --nsg-name $vm-NSG --priority 400

	#create public IP
	az network public-ip create --resource-group AzureProject --name $vm-IP --dns-name $vm-123456789

	#create network interface card for corresponding user
	az network nic create --resource-group AzureProject --name $vm-nic --vnet-name AzureProject-VirtualNetwork --subnet MySubnet --network-security-group $vm-NSG --public-ip-address $vm-IP
	#create virtual machine for corresponding user
	az vm create --resource-group AzureProject --name $vm --image UbuntuLTS --nics $vm-nic --admin-username "nstephenson" --size Standard_F1 --generate-ssh-keys
done
