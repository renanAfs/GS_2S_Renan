resource "azurerm_resource_group" "rg" {
    name     = "rg-gsrenan"
    location = "brazilsouth"
}

resource "azurerm_virtual_network" "vneta" {
    name                = "vneta"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "snvnetapub1a" {
    name                 = "snvnetapub1a"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vneta.name
    address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "snvnetapub1b" {
    name                 = "snvnetapub1b"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vneta.name
    address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "nsgvneta" {
    name                = "nsgvneta"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    security_rule {
        name                       = "AllowInternetSshInbound"
        priority                   = 1011
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
    }
}

resource "azurerm_subnet_network_security_group_association" "nsgsnvnetapub1a" {
    subnet_id                 = azurerm_subnet.snvnetapub1a.id
    network_security_group_id = azurerm_network_security_group.nsgvneta.id
}

resource "azurerm_subnet_network_security_group_association" "nsgsnvnetapub1b" {
    subnet_id                 = azurerm_subnet.snvnetapub1b.id
    network_security_group_id = azurerm_network_security_group.nsgvneta.id
}