provider "azurerm" {
  features {}
}

# 1. Create the Resource Group
resource "azurerm_resource_group" "rg-1" {
  name     = "${local.prefix}${var.rg_name}"
  location = "centralindia"
  tags = {
    Environment = var.tags[0]
  }
}

# 2. Create the Storage Account
resource "azurerm_storage_account" "store1" {
  name                     = "${local.prefix}${var.storage_account_name}"
  resource_group_name      = azurerm_resource_group.rg-1.name
  location                 = azurerm_resource_group.rg-1.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  public_network_access_enabled = var.storage_public_access
  
  tags = {
    Environment = var.tags[1]
  }
}

# 3. Create the Storage Container inside the Storage Account
resource "azurerm_storage_container" "pri-store1" {
  name                  = "${local.prefix}${var.private_container_name}"
  storage_account_id    = azurerm_storage_account.store1.id
  container_access_type = "private"
  
  
}



locals {
    prefix = "nihar"
}



output "rg_name" {
  value = azurerm_resource_group.rg-1.name
}

output "storage_account_id" {
  value     = azurerm_storage_container.pri-store1.id
  sensitive = true
}