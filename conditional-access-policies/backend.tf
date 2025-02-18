terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "sensiniadtfstate713"
    container_name      = "tfstate"
    key                 = "conditional-access.tfstate"
  }
}