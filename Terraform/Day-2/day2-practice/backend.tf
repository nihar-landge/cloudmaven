terraform {
  backend "azurerm" {
    resource_group_name  = "nihar-rg"
    storage_account_name = "niharstorage2"
    container_name       = "pre-store"            
    key                  = "infrastructure.terraform.tfstate" 
  }
}