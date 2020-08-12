locals {
  type_codes = {
    "DevTest" = "MS-AZR-0148P",
    "Prod"    = "MS-AZR-0017P"
  }
}

# Note that the subscription cannot be programmatically deleted, 
# it is just removed from Terraform's state file
resource "shell_script" "subscription" {
  working_directory = path.module
  lifecycle_commands {
    create = ". ./subscription.ps1; Create"
    read   = ". ./subscription.ps1; Read"
    update = ". ./subscription.ps1; Update"
    delete = ". ./subscription.ps1; Delete"
  }
  environment = {
    name   = var.name
    tenant = var.tenant_id
    type   = local.type_codes[var.type]
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "owners" {
  for_each             = toset(var.principal_ids)
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Owner"
  principal_id         = each.key
}
