# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "tfc_hostname" {
  type        = string
  default     = "app.terraform.io"
  description = "The hostname of the TFC or TFE instance you'd like to use with Azure"
}

variable "tfc_organization_name" {
  type        = string
  description = "The name of your Terraform Cloud organization"
  default     = "philbrook"
}

variable "github_organization" {
  type        = string
  description = "The name of your GitHub organization"
  default     = "nphilbrook"
}

variable "az_subscription_id" {
  type        = string
  description = "Azure Subscription ID where resources will be created"
}

variable "az_tenant_id" {
  type        = string
  description = "Azure Tenant ID"
}

variable "az_client_id" {
  type        = string
  description = "Azure Client ID"
}
