terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatebackend001"
    container_name       = "tfstate"
    key                  = "cdn-profile/terraform.tfstate"
  }
}
