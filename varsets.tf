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

# All workspaces and stacks in this project have access to this varset
resource "tfe_project_variable_set" "azure_creds_attach" {
  project_id      = tfe_project.azure.id
  variable_set_id = tfe_variable_set.azure_creds.id
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

resource "tfe_variable" "tfe_token" {
  variable_set_id = tfe_variable_set.azure_creds.id

  key       = "TFE_TOKEN"
  value     = var.tfe_token
  category  = "env"
  sensitive = true
}

resource "tfe_variable" "ssh_public_key" {
  variable_set_id = tfe_variable_set.azure_creds.id

  key      = "ssh_public_key"
  value    = var.ssh_public_key
  category = "env"
}

# ARM_CLIENT_SECRET is click-ops'd in HCPt
# vault_license is click-ops'd in HCPt

# non-auth related shared stuff to propagate down to everywhere
resource "tfe_variable_set" "azure_config" {
  name              = "Azure Config"
  global            = false
  parent_project_id = tfe_project.azure.id
}

# All workspaces and stacks in this project have access to this varset
resource "tfe_project_variable_set" "azure_config_attach" {
  project_id      = tfe_project.azure.id
  variable_set_id = tfe_variable_set.azure_config.id
}

resource "tfe_variable" "ingress_ips" {
  variable_set_id = tfe_variable_set.azure_config.id

  key      = "ingress_ips"
  value    = provider::terraform::encode_expr(var.ingress_ips)
  category = "terraform"
  hcl      = true

  description = "IPs that should be allowed to ingress to various resources on the vnet"
}
