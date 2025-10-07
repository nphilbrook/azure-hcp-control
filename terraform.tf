terraform {
  required_version = "~>1.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.47"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>3.6"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~>0.70"
    }
  }
}
