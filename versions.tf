terraform {
  required_version = ">= 1.4.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      # combined constraints from all modules:
      # "~> 3.100", "~> 3.71", ">= 3.116, < 5"
      version = ">= 3.116, < 5"
    }

    random = {
      source  = "hashicorp/random"
      # combined from "~> 3.5" and "~> 3.6"
      version = "~> 3.6"
    }

    modtm = {
      source  = "azure/modtm"
      version = "~> 0.3"
    }

    azapi = {
      source  = "azure/azapi"
      # coming from your autoscale module
      version = ">= 1.13, != 1.13.0, < 2"
    }
  }
}
