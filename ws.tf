resource "tfe_workspace" "azure_core_infra" {
  name              = "azure-core-infra-ws"
  project_id        = tfe_project.azure.id
  terraform_version = "1.13.4"
  vcs_repo {
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
    identifier                 = "${var.github_organization}/azure-core-infra-ws"
  }
}

resource "tfe_workspace" "azure_vault_hvd" {
  name              = "azure-vault-hvd-ws"
  project_id        = tfe_project.azure.id
  terraform_version = "1.13.4"
  vcs_repo {
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
    identifier                 = "${var.github_organization}/azure-vault-hvd-ws"
  }
}

resource "tfe_workspace_settings" "azure_core_infra_settings" {
  workspace_id              = tfe_workspace.azure_core_infra.id
  remote_state_consumer_ids = [tfe_workspace.azure_vault_hvd.id]
}
