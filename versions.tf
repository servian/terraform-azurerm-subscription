terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm  = "~> 2.19"
    external = "~> 1.2"
    shell = {
      source  = "scottwinkler/shell"
      version = "=1.7.2"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

data "external" "az_client_config" {
  program = ["pwsh", "-command", "@{tenant=$env:ARM_TENANT_ID;client=$env:ARM_CLIENT_ID;secret=$env:ARM_CLIENT_SECRET} | ConvertTo-Json | Write-Output"]
}

provider "shell" {
  interpreter = ["pwsh", "-command"]

  sensitive_environment = {
    azsub_client_id     = data.external.az_client_config.result.client
    azsub_client_secret = data.external.az_client_config.result.secret
    azsub_tenant_id     = data.azurerm_client_config.current.tenant_id
  }
}
