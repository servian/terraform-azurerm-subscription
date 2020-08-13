terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = "~> 2.19"
    shell = {
      source  = "scottwinkler/shell"
      version = "=1.7.2"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = shell_script.subscription.output.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

provider "shell" {
  interpreter = ["pwsh", "-command"]

  sensitive_environment = {
    azsub_client_id     = var.client_id
    azsub_client_secret = var.client_secret
  }
}
