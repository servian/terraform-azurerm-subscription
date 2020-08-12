> Note: The subscription cannot be programmatically deleted, it is just removed from Terraform's state file.

## Additional Requirements

### Required Permissions

The user or service principal executing this module requires the ability to create subscriptions with an Azure Enrollment Account (with the `Owner` role). See the [Azure Documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/grant-access-to-create-subscription?#grant-access) for how to grant this.

### PowerShell Dependencies

As this module uses the Az PowerShell commands it requires that PowerShell Core and the following modules are installed on the deployment agent:

- PowerShell Core (~>7.0)
- PS Module: `Az` (~>4.5)
- PS Module: `Az.Accounts` (~>1.9)
- PS Module: `Az.Subscription` (~>0.7)

```powershell
Install-Module @("Az", "Az.Accounts", "Az.Subscription")
```

## Usage Example

```hcl
module "subscription" {
  source        = "servian/subscription/azurerm"
  name          = "My Subscription"
  tenant_id     = "00000000-0000-0000-0000-000000000000"
  client_id     = "00000000-0000-0000-0000-000000000000"
  client_secret = "super-S3cr37!"
}
```
