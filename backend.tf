terraform {
  cloud {
    organization = "philbrook"
    workspaces {
      name = "azure-hcp-control"
    }
  }
}
