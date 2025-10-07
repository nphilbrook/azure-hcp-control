# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  azure_audience = "api://AzureADTokenExchange"
}

# Data source used to get information about the current Azure AD tenant.
#
# https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config
data "azuread_client_config" "current" {}

# Data source used to get the current subscription's ID.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription
data "azurerm_subscription" "current" {
}

# Ref https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_api_access#example-usage
data "azuread_application_published_app_ids" "well_known" {}

data "azuread_service_principal" "msgraph" {
  client_id = data.azuread_application_published_app_ids.well_known.result["MicrosoftGraph"]
}

# Creates an application registration within Azure Active Directory.
#
# https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application
resource "azuread_application" "tfc_application" {
  display_name = "philbrook-tf-application"
  owners       = [data.azuread_client_config.current.object_id]
}

# azuread permissions
resource "azuread_application_api_access" "example_msgraph" {
  application_id = azuread_application.tfc_application.id
  api_client_id  = data.azuread_application_published_app_ids.well_known.result["MicrosoftGraph"]

  role_ids = [
    data.azuread_service_principal.msgraph.app_role_ids["Application.ReadWrite.All"]
  ]
}

# Creates a service principal associated with the previously created
# application registration.
#
# https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal
resource "azuread_service_principal" "tfc_service_principal" {
  # application_id = azuread_application.tfc_application.application_id
  client_id = azuread_application.tfc_application.client_id
}

# Creates a role assignment which controls the permissions the service
# principal has within the Azure subscription.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
resource "azurerm_role_assignment" "tfc_role_assignment" {
  scope                = data.azurerm_subscription.current.id
  principal_id         = azuread_service_principal.tfc_service_principal.object_id
  role_definition_name = "Owner"
}

# Creates a federated identity credential which ensures that the given
# workspace will be able to authenticate to Azure for the "plan" run phase.
#
# https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_federated_identity_credential
resource "azuread_application_federated_identity_credential" "tfc_federated_credential_plan" {
  application_id = azuread_application.tfc_application.id
  display_name   = "philbrook-tf-federated-credential-plan"
  audiences      = [local.azure_audience]
  issuer         = "https://${var.tfc_hostname}"
  subject        = "organization:${var.tfc_organization_name}:project:${tfe_project.azure.name}:workspace:${tfe_workspace.self.name}:run_phase:plan"
}

# Creates a federated identity credential which ensures that the given
# workspace will be able to authenticate to Azure for the "apply" run phase.
#
# https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_federated_identity_credential
resource "azuread_application_federated_identity_credential" "tfc_federated_credential_apply" {
  application_id = azuread_application.tfc_application.id
  display_name   = "philbrook-tf-federated-credential-apply"
  audiences      = [local.azure_audience]
  issuer         = "https://${var.tfc_hostname}"
  subject        = "organization:${var.tfc_organization_name}:project:${tfe_project.azure.name}:workspace:${tfe_workspace.self.name}:run_phase:apply"
}
