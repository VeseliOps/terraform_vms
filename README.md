# Created an Azure VM using **Terraform** for Docker Swarm
1. Install Terraform, in my case I am using Ubuntu 22.04
2. Install Terraform extension in your VSCode. Files must have .tf extension
3. Download and Install Azure CLI 
4. Start writing your script
###  Important commands:
- terraform init (Downloads all neccessary dependencies)
- terraform plan (Shows changes that are going to be made, + adding new , - removing, ~ modified)
- terraform apply 
- terraform destroy (:exclamation: IMPORTANT to type a name of instance/VM that you want to remove :exclamation:)
### Azure CLI 
- az login
- az login --tenant name.onmicrosoft.com
### Neccessary port for Docker Swarm
- TCP 2377 - for cluster managment communication
- TCP 7964 - for communication among nodes
- UDP 4789 - for overlay network traffic
