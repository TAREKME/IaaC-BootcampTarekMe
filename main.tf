resource "azurerm_resource_group" "IaaCBC" {
  name     = "IaaCBCRG"
  location = "West Europe"
}

resource "azurerm_network_security_group" "IaaCBC" {
  name                = "IaaCBC-security-group"
  location            = azurerm_resource_group.IaaCBC.location
  resource_group_name = azurerm_resource_group.IaaCBC.name
}

resource "azurerm_virtual_network" "IaaCBC" {
  name                = "IaaCBC-network"
  location            = azurerm_resource_group.IaaCBC.location
  resource_group_name = azurerm_resource_group.IaaCBC.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.IaaCBC.id
  }

  tags = {
    environment = "IaaCBC"
  }

  resource "azurerm_network_interface" "example" {
  name                = "IaaCBCVMWIN-nic"
  location            = azurerm_resource_group.IaaCBC.location
  resource_group_name = azurerm_resource_group.IaaCBC.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_virtual_network.subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
  }
}