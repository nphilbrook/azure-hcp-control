data "tfe_github_app_installation" "gha_installation" {
  name = var.github_organization
}

resource "tfe_project" "azure" {
  name        = "azure"
  description = "Project for Azure resources"
}

resource "tfe_workspace" "self" {
  name       = "azure-hcp-control"
  project_id = tfe_project.azure.id
  vcs_repo {
    identifier                 = "${var.github_organization}/azure-hcp-control"
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
  }
}

resource "tfe_workspace_settings" "self" {
  workspace_id   = tfe_workspace.self.id
  execution_mode = "remote"
}

