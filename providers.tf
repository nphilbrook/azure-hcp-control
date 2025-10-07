provider "azurerm" {
  use_cli                         = false
  resource_provider_registrations = "none"
  features {}
  subscription_id = var.az_subscription_id
  tenant_id       = var.az_tenant_id
}

# provider "azuread" {
#   use_cli   = false
#   tenant_id = var.az_tenant_id
# }

provider "tfe" {
  organization = var.tfc_organization_name
  hostname     = var.tfc_hostname
}
