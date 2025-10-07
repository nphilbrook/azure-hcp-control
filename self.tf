data "tfe_github_app_installation" "gha_installation" {
  name = "nphilbrook"
}

resource "tfe_project" "azure" {
  name        = "azure"
  description = "Project for Azure resources"
}

resource "tfe_workspace" "self" {
  name         = "azure-core-infra"
  project_id   = tfe_project.azure.id
  organization = "philbrook"
  vcs_repo {
    identifier                 = "nphilbrook/azure-core-infra"
    branch                     = "main"
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
  }
}

resource "tfe_workspace_settings" "self" {
  workspace_id   = tfe_workspace.self.id
  execution_mode = "remote"
}

# The following variables must be set to allow runs
# to authenticate to Azure.
#
# https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable
resource "tfe_variable" "enable_azure_provider_auth" {
  workspace_id = tfe_workspace.self.id

  key      = "TFC_AZURE_PROVIDER_AUTH"
  value    = "true"
  category = "env"

  description = "Enable the Workload Identity integration for Azure."
}

resource "tfe_variable" "tfc_azure_client_id" {
  workspace_id = tfe_workspace.self.id

  key      = "TFC_AZURE_RUN_CLIENT_ID"
  value    = azuread_application.tfc_application.id
  category = "env"

  description = "The Azure Client ID runs will use to authenticate."
}
