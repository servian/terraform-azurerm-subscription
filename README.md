## Additional Requirements

### Required Permissions

The user or service principal executing this module requires the ability to create subscriptions against an Azure Enrollment Account (`Owner` role). See the [Azure Documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/grant-access-to-create-subscription?#grant-access) for how to grant this.

### PowerShell Dependencies

As this module uses the Az PowerShell commands it requires that the azurerm provider config is set using environment variables so it can authenticate. These modules are required to be installed on the deployment agent:

- PowerShell Core (~>7.0)
- PS Module: Az (~>4.5)
- PS Module: Az.Accounts (~>1.9)
- PS Module: Az.Subscription (~>0.7)

```powershell
Install-Module @("Az", "Az.Accounts", "Az.Subscription")
```

## Usage Example

```hcl
module "subscription" {
  source  = "servian/subscription/azurerm"
  name    = "My Subscription"
  type    = "Prod"
}
```
