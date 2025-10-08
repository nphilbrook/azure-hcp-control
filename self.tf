data "tfe_github_app_installation" "gha_installation" {
  name = "nphilbrook"
}

resource "tfe_project" "azure" {
  name        = "azure"
  description = "Project for Azure resources"
}

resource "tfe_workspace" "self" {
  name         = "azure-hcp-control"
  project_id   = tfe_project.azure.id
  organization = "philbrook"
  vcs_repo {
    identifier                 = "nphilbrook/azure-hcp-control"
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
  }
}

resource "tfe_workspace_settings" "self" {
  workspace_id   = tfe_workspace.self.id
  execution_mode = "remote"
}

# The following variables must be set to allow runs
# to authenticate to Azure.

# What is the point of reading these in as workspace Terraform variables and
# writing them back out as environment variables in a variable set?
# So that other workspaces can get the same creds. Update once in 
# the workspace linked to this repo, and all other workspaces that
# use the varset will get the update.

resource "tfe_variable_set" "azure_creds" {
  name              = "Azure Credentials"
  global            = false
  parent_project_id = tfe_project.azure.id
}

resource "tfe_variable" "arm_client_id" {
  variable_set_id = tfe_variable_set.azure_creds.id

  key      = "ARM_CLIENT_ID"
  value    = var.az_client_id
  category = "env"
}

resource "tfe_variable" "arm_subscription_id" {
  variable_set_id = tfe_variable_set.azure_creds.id

  key      = "ARM_SUBSCRIPTION_ID"
  value    = var.az_subscription_id
  category = "env"
}

resource "tfe_variable" "arm_tenant_id" {
  variable_set_id = tfe_variable_set.azure_creds.id

  key      = "ARM_TENANT_ID"
  value    = var.az_tenant_id
  category = "env"
}

resource "tfe_project_variable_set" "azure_creds_attach" {
  project_id      = tfe_project.azure.id
  variable_set_id = tfe_variable_set.azure_creds.id
}

# ARM_CLIENT_SECRET is click-ops'd in HCPt
