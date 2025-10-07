terraform {
  cloud {
    organization = "philbrook"
    workspaces {
      name = "azure-core-infra"
    }
  }
}
