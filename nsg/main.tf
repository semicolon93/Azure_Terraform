#creating resource group
resource "azurerm_resource_group" "example" {
  name     = "NSG_Group1"
  location = "West US"
}

#creating network security group
resource "azurerm_network_security_group" "example" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

#fetching data from the csv file
locals{
  nsg_rule = csvdecode(file("./rules.csv"))
  }

#creating network security rules as per the data from the csv file
resource "azurerm_network_security_rule" "example" {
  
    count = length(local.nsg_rule)
  
  name                        = local.nsg_rule[count.index].Name
  priority                    = local.nsg_rule[count.index].Priority
  direction                   = local.nsg_rule[count.index].Direction
  access                      = local.nsg_rule[count.index].Access
  protocol                    = local.nsg_rule[count.index].Protocol
  source_port_range           = local.nsg_rule[count.index].Source_Port_Range
  destination_port_range      = local.nsg_rule[count.index].Destination_Port_Range
  source_address_prefix       = local.nsg_rule[count.index].Source_Address_Prefix
  destination_address_prefix  = local.nsg_rule[count.index].Destination_Address_Prefix
  
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.example.name
}
