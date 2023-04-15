terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
    
   features {

 }

}
variable "resgroup2" {
  default = "RES-GRP-CT360-TUTORING-GRP4"
}
variable "loc2" {
  default = "West Europe"
}

resource "azurerm_virtual_network" "veselinet2" {
  name                = "veseli2-network-tf"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.loc2}"
  resource_group_name = "${var.resgroup2}"
}
resource "azurerm_public_ip" "nzm2" {
    name                         = "veseliip2"
    location                     = "${var.loc2}"
    resource_group_name          = "${var.resgroup2}"
    allocation_method            = "Static"

}

resource "azurerm_subnet" "veselisubnet2" {
  name                 = "vmsubnet2"
  resource_group_name  = "${var.resgroup2}"
  virtual_network_name =  azurerm_virtual_network.veselinet2.name
  address_prefixes     = ["10.0.2.0/24"]
  
}
resource "azurerm_network_interface" "nic2" {
  name                = "example-nic2"
  location            = "${var.loc2}"
  resource_group_name = "${var.resgroup2}"

   ip_configuration {
        name                           = "internal"
        subnet_id                      =  azurerm_subnet.veselisubnet2.id
        private_ip_address_allocation  = "Dynamic"
        public_ip_address_id           =  azurerm_public_ip.nzm2.id
    }
}
resource "azurerm_linux_virtual_machine" "vm2" { 
  name                = "veselamasina-tf2"
  resource_group_name = "${var.resgroup2}"
  location            = "${var.loc2}"
  size                = "Standard_F2"
  admin_username      = "veselitf2"
  network_interface_ids = [
    azurerm_network_interface.nic2.id,
  ]

  admin_ssh_key {
    username   = "veselitf2"
    public_key = file("~/.ssh/id_rsa2.pub")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
# OVO SU PORTOVI ZA DOCKER SWARM
resource "azurerm_network_security_group" "my_terraform_nsg2" {
  name                = "myNetworkSecurityGroup2"
  location            = "${var.loc2}"
  resource_group_name = "${var.resgroup2}"

  security_rule {
    name                       = "SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "UDP"
    priority                   = 1110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "4789"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "TCP-UDP"
    priority                   = 1210
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "7946"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "TCP"
    priority                   = 1310
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "2377"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_network_interface_security_group_association" "nsg2" {
  network_interface_id      = azurerm_network_interface.nic2.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg2.id
}
