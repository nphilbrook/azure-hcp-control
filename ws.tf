resource "tfe_workspace" "azure_core_infra" {
  name       = "azure-core-infra-ws"
  project_id = tfe_project.azure.id
  vcs_repo {
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
    identifier                 = "${var.github_organization}/azure-core-infra-ws"
  }
}

resource "tfe_workspace" "azure_vault_hvd" {
  name       = "azure-vault-hvd-ws"
  project_id = tfe_project.azure.id
  vcs_repo {
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
    identifier                 = "${var.github_organization}/azure-vault-hvd-ws"
  }
}
