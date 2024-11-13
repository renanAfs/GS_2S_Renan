output "rgname" {
 value = azurerm_resource_group.rg.name
}

output "rglocation" {
 value = azurerm_resource_group.rg.location
}

output "vneta" {
 value = azurerm_virtual_network.vneta.id
}

output "snvnetapub1a" {
 value = azurerm_subnet.snvnetapub1a.id
}

output "snvnetapub1b" {
 value = azurerm_subnet.snvnetapub1b.id
}


