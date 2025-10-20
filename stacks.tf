# 404 bug making these unusable - removed from state for now

# resource "tfe_stack" "azure_core_infra" {
#   name       = "azure-core-infra"
#   project_id = tfe_project.azure.id
#   vcs_repo {
#     github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
#     identifier                 = "${var.github_organization}/azure-core-infra"
#   }
# }

# resource "tfe_stack" "azure_vault_hvd" {
#   name       = "azure-vault-hvd"
#   project_id = tfe_project.azure.id
#   vcs_repo {
#     github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
#     identifier                 = "${var.github_organization}/azure-vault-hvd"
#   }
# }
