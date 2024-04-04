terraform {
  backend "azurerm" {
    resource_group_name  = "backendrg"
    storage_account_name = "backendtf182324"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}
