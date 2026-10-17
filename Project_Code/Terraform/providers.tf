terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

# Azure Provider with Service Principal authentication
provider "azurerm" {
  features {}

  subscription_id = ""
  tenant_id       = ""
}