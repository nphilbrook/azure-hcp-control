provider "azurerm" {
  resource_provider_registrations = "none"
  features {}
  subscription_id = var.az_subscription_id
}

provider "azuread" {
}

provider "tfe" {
}
