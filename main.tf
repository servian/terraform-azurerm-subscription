locals {
  type_codes = {
    "DevTest" = "MS-AZR-0148P",
    "Prod"    = "MS-AZR-0017P"
  }
}

data "azurerm_client_config" "current" {}

data "external" "az_client_config" {
  program = ["pwsh", "-command", "@{tenant=$env:ARM_TENANT_ID;client=$env:ARM_CLIENT_ID;secret=$env:ARM_CLIENT_SECRET} | ConvertTo-Json | Write-Output"]
}

resource "shell_script" "subscription" {
  working_directory = path.module
  interpreter = ["pwsh", "-command"]
  lifecycle_commands {
    create = ". ./subscription.ps1; Create"
    read   = ". ./subscription.ps1; Read"
    update = ". ./subscription.ps1; Update"
    delete = ". ./subscription.ps1; Delete"
  }
  environment = {
    name = var.name
    type = local.type_codes[var.type]
  }
  sensitive_environment = {
    azsub_client_id     = data.external.az_client_config.result.client
    azsub_client_secret = data.external.az_client_config.result.secret
    azsub_tenant_id     = data.azurerm_client_config.current.tenant_id
  }
}
